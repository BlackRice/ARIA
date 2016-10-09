using UnityEngine;

[ExecuteInEditMode]
public class Decal:MonoBehaviour
{
	public Material material;
	public float renderQueue;

	public void OnWillRenderObject()
	{
		DeferredDecalRenderer renderer = Camera.current.gameObject.GetComponent<DeferredDecalRenderer>();

		if (!renderer)
		{
			return;
		}

		renderer.AddToRenderQueue(this);
	}
}
