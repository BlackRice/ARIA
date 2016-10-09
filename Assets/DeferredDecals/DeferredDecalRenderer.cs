using UnityEngine;
using UnityEngine.Rendering;
using System.Collections;
using System.Collections.Generic;

#if UNITY_EDITOR
using UnityEditor;
#endif

/*
public class DeferredDecalSystem
{
	static DeferredDecalSystem m_Instance;
	static public DeferredDecalSystem instance
	{
		get
		{
			if (m_Instance == null)
				m_Instance = new DeferredDecalSystem();
			return m_Instance;
		}
	}
	
	internal HashSet<Decal> decals = new HashSet<Decal>();

	public void AddDecal(Decal d)
	{
		RemoveDecal(d);
		decals.Add(d);
	}
	public void RemoveDecal(Decal d)
	{
		decals.Remove(d);
	}

	public void ClearDecals()
	{
		decals.Clear();
	}
}
*/

[ExecuteInEditMode]
public class DeferredDecalRenderer:MonoBehaviour
{
	//private Dictionary<Camera, CommandBuffer> m_Cameras = new Dictionary<Camera, CommandBuffer>();

	private Camera _camera;
	new public Camera camera
	{
		get
		{
			return _camera ? _camera : _camera = gameObject.GetComponent<Camera>();
		}
	}

	private HashSet<Decal> decals = new HashSet<Decal>();
	private List<Decal> decalSortedList = new List<Decal>();
	private CommandBuffer commandBuffer;

	public void AddToRenderQueue(Decal decal)
	{
		if (!decals.Contains(decal))
		{
			decals.Add(decal);
		}
	}

	private void ClearDecals()
	{
		decals.Clear();
	}

	public void OnDisable()
	{
		if (commandBuffer != null)
		{
			camera.RemoveCommandBuffer(CameraEvent.BeforeReflections, commandBuffer);
			commandBuffer.Dispose();
			commandBuffer = null;
		}

		/*
		foreach (var cam in m_Cameras)
		{
			if (cam.Key)
			{
				cam.Key.RemoveCommandBuffer(CameraEvent.BeforeReflections, cam.Value);
			}
		}
		*/
	}

#if UNITY_EDITOR
	void Update()
	{
		Camera[] sceneCameras = SceneView.GetAllSceneCameras();
		foreach (var cam in sceneCameras)
		{
			DeferredDecalRenderer deferredDecalRenderer = cam.gameObject.GetComponent<DeferredDecalRenderer>();
			if (!deferredDecalRenderer)
			{
				cam.gameObject.AddComponent<DeferredDecalRenderer>();
			}
		}
	}
#endif

	void OnPreCull()
	{
		camera.depthTextureMode |= DepthTextureMode.DepthNormals;

		if (!camera)
		{
			return;
		}

		if (!(gameObject.activeInHierarchy && enabled))
		{
			OnDisable();
			return;
		}
		
		if (commandBuffer == null)
		{
			commandBuffer = new CommandBuffer();
			commandBuffer.name = "Deferred decals";
			camera.AddCommandBuffer(CameraEvent.BeforeReflections, commandBuffer);
		}

		commandBuffer.Clear();

		/*
		if (m_Cameras.ContainsKey(cam))
		{
			buf = m_Cameras[cam];
			buf.Clear();
		}
		else
		{
			buf = new CommandBuffer();
			buf.name = "Deferred decals";
			m_Cameras[cam] = buf;

			// set this command buffer to be executed just before deferred lighting pass
			// in the camera
			cam.AddCommandBuffer(CameraEvent.BeforeReflections, buf);
		}
		*/

		decalSortedList.Clear();
		decalSortedList.AddRange(decals);

		decalSortedList.Sort((v0, v1) => v0.renderQueue.CompareTo(v1.renderQueue));

		var copy0ID = Shader.PropertyToID("_CameraGBufferTexture0DecalCopy");
		var copy1ID = Shader.PropertyToID("_CameraGBufferTexture1DecalCopy");
		var copy2ID = Shader.PropertyToID("_CameraGBufferTexture2DecalCopy");
		var copy3ID = Shader.PropertyToID("_CameraGBufferTexture3DecalCopy");

		commandBuffer.GetTemporaryRT(copy0ID, camera.pixelWidth, camera.pixelHeight, 0, FilterMode.Point, RenderTextureFormat.ARGB32);
		commandBuffer.GetTemporaryRT(copy1ID, camera.pixelWidth, camera.pixelHeight, 0, FilterMode.Point, RenderTextureFormat.ARGB32);
		commandBuffer.GetTemporaryRT(copy2ID, camera.pixelWidth, camera.pixelHeight, 0, FilterMode.Point, RenderTextureFormat.ARGB2101010);
		commandBuffer.GetTemporaryRT(copy3ID, camera.pixelWidth, camera.pixelHeight, 0, FilterMode.Point, RenderTextureFormat.ARGBHalf);

		commandBuffer.Blit(BuiltinRenderTextureType.GBuffer0, copy0ID);
		commandBuffer.Blit(BuiltinRenderTextureType.GBuffer1, copy1ID);
		commandBuffer.Blit(BuiltinRenderTextureType.GBuffer2, copy2ID);
		commandBuffer.Blit(BuiltinRenderTextureType.CameraTarget, copy3ID);
		
		RenderTargetIdentifier[] mrt = {
			BuiltinRenderTextureType.GBuffer0,
			BuiltinRenderTextureType.GBuffer1,
			BuiltinRenderTextureType.GBuffer2,
			BuiltinRenderTextureType.CameraTarget
		};

		RenderTargetIdentifier[] mrt2 = new RenderTargetIdentifier[4];
		mrt2[0] = new RenderTargetIdentifier(copy0ID);
		mrt2[1] = new RenderTargetIdentifier(copy1ID);
		mrt2[2] = new RenderTargetIdentifier(copy2ID);
		mrt2[3] = new RenderTargetIdentifier(copy3ID);

		foreach (var decal in decalSortedList)
		{
			
			if (!decal)
			{
				continue;
			}

			if (!decal.material)
			{
				continue;
			}

			Renderer renderer = decal.GetComponent<Renderer>();

			if (!renderer)
			{
				continue;
			}

			commandBuffer.SetRenderTarget(mrt, BuiltinRenderTextureType.CameraTarget);
			commandBuffer.DrawRenderer(renderer, decal.material, 0, 0);

			commandBuffer.SetRenderTarget(mrt2, BuiltinRenderTextureType.CameraTarget);
			commandBuffer.DrawRenderer(renderer, decal.material, 0, 1);
		}

		commandBuffer.ReleaseTemporaryRT(copy0ID);
		commandBuffer.ReleaseTemporaryRT(copy1ID);
		commandBuffer.ReleaseTemporaryRT(copy2ID);
		commandBuffer.ReleaseTemporaryRT(copy3ID);

		ClearDecals();
	}
}
