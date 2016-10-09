Shader "Decal/StandardDecal"
{
    Properties
    {
        _MainTex("Diffuse", 2D) = "white" {}
		_DiffuseStrength("DiffuseStrength", Range(0.0, 1.0)) = 1.0
        _Glossiness("Smoothness", Range(0.0, 1.0)) = 1
        [Gamma] _Metallic("Metallic", Range(0.0, 1.0)) = 1
        _MetallicGlossMap("MetallicSmoothnessTex", 2D) = "white" {}
		_SpecularStrength("SpecularStrength", Range(0.0, 1.0)) = 1.0
		_SmoothnessStrength("SmoothnessStrength", Range(0.0, 1.0)) = 1.0
        _OcclusionMap("OcclusionTex", 2D) = "white" {}
		_OcclusionStrength("OcclusionStrength", Range(0.0, 1.0)) = 1.0
        _BumpMap("Normals", 2D) = "bump" {}
		_NormalStrength("NormalStrength", Range(0.0, 1.0)) = 1.0
        _ParallaxMap("HeightMap", 2D) = "gray" {}
        _Parallax("HeightFactor", Range(0, 0.08)) = 0
    }
        SubShader
    {
        Tags{ "RenderType" = "Opaque" "PerformanceChecks" = "False" }
        ZWrite Off
        Offset -1, -1

        Pass
    {
        Name "DEFERRED"
        Tags{ "LightMode" = "Deferred" }
            
        CGPROGRAM
#pragma target 3.0
        // TEMPORARY: GLES2.0 temporarily disabled to prevent errors spam on devices without textureCubeLodEXT
#pragma exclude_renderers nomrt gles


        // -------------------------------------

#pragma shader_feature _NORMALMAP
#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
#pragma shader_feature _EMISSION
#pragma shader_feature _METALLICGLOSSMAP
#pragma shader_feature ___ _DETAIL_MULX2
#pragma shader_feature _PARALLAXMAP

#pragma multi_compile ___ UNITY_HDR_ON
#pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
#pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
#pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON

//#define _TANGENT_TO_WORLD 1
#define _PARALLAXMAP 1

#pragma vertex vertDecalDeferred
#pragma fragment fragDecalDeferred

#include "UnityStandardCore.cginc"

    struct VertexInputDecal
    {
        float4 vertex	: POSITION;
        half3 normal	: NORMAL;
        float2 uv0		: TEXCOORD0;
        float2 uv1		: TEXCOORD1;
        float2 uv2		: TEXCOORD2;
        half4 tangent	: TANGENT;
    };

    struct VertexOutputDeferredDecal
    {
        float4 pos							: SV_POSITION;
        float4 tex							: TEXCOORD0;
        half3 eyeVec 						: TEXCOORD1;
        half4 tangentToWorldAndParallax[3]	: TEXCOORD2;	// [3x3:tangentToWorld | 1x3:viewDirForParallax]
        half4 ambientOrLightmapUV			: TEXCOORD5;	// SH or Lightmap UVs			
#if UNITY_SPECCUBE_BOX_PROJECTION
        float3 posWorld						: TEXCOORD6;
#endif
#if UNITY_OPTIMIZE_TEXCUBELOD
#if UNITY_SPECCUBE_BOX_PROJECTION
        half3 reflUVW				: TEXCOORD7;
#else
        half3 reflUVW				: TEXCOORD6;
#endif
#endif

        float4 screenUV : TEXCOORD8;
        float4 tangent: TANGENT;
        float3 normal: NORMAL;

    };

        //sampler2D _MainTex;
        //sampler2D _MetallicGlossMap;
        //sampler2D _OcclusionMap;
        //sampler2D _BumpMap;
        sampler2D_float _CameraDepthTexture;
        sampler2D_float _DepthCopy;
        float _NormalFadeFactor;
        //sampler2D _ParallaxMap;
        //float _Parallax;

        sampler2D _CameraGBufferTexture0DecalCopy;
        sampler2D _CameraGBufferTexture1DecalCopy;
        sampler2D _CameraGBufferTexture2DecalCopy;
        sampler2D _CameraGBufferTexture3DecalCopy;

		float _DiffuseStrength;
		float _SpecularStrength;
		float _SmoothnessStrength;
		float _NormalStrength;

        VertexOutputDeferredDecal vertDecalDeferred(VertexInputDecal v)
    {
        VertexOutputDeferredDecal o;
        UNITY_INITIALIZE_OUTPUT(VertexOutputDeferredDecal, o);

        float4 posWorld = mul(unity_ObjectToWorld, v.vertex);
#if UNITY_SPECCUBE_BOX_PROJECTION
        o.posWorld = posWorld;
#endif
        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.tex = float4(v.uv0, 0, 0);
        o.eyeVec = NormalizePerVertexNormal(posWorld.xyz - _WorldSpaceCameraPos);
        float3 normalWorld = UnityObjectToWorldNormal(v.normal);
#ifdef _TANGENT_TO_WORLD
        float4 tangentWorld = float4(UnityObjectToWorldDir(v.tangent.xyz), v.tangent.w);

        float3x3 tangentToWorld = CreateTangentToWorldPerVertex(normalWorld, tangentWorld.xyz, tangentWorld.w);
        o.tangentToWorldAndParallax[0].xyz = tangentToWorld[0];
        o.tangentToWorldAndParallax[1].xyz = tangentToWorld[1];
        o.tangentToWorldAndParallax[2].xyz = tangentToWorld[2];
#else
        o.tangentToWorldAndParallax[0].xyz = 0;
        o.tangentToWorldAndParallax[1].xyz = 0;
        o.tangentToWorldAndParallax[2].xyz = normalWorld;
#endif

        o.ambientOrLightmapUV = 0;
#ifndef LIGHTMAP_OFF
        o.ambientOrLightmapUV.xy = v.uv1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
#elif UNITY_SHOULD_SAMPLE_SH
        o.ambientOrLightmapUV.rgb = ShadeSHPerVertex(normalWorld, o.ambientOrLightmapUV.rgb);
#endif
#ifdef DYNAMICLIGHTMAP_ON
        o.ambientOrLightmapUV.zw = v.uv2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
#endif

#ifdef _PARALLAXMAP
        TANGENT_SPACE_ROTATION;
        half3 viewDirForParallax = mul(rotation, ObjSpaceViewDir(v.vertex));
        o.tangentToWorldAndParallax[0].w = viewDirForParallax.x;
        o.tangentToWorldAndParallax[1].w = viewDirForParallax.y;
        o.tangentToWorldAndParallax[2].w = viewDirForParallax.z;
#endif

#if UNITY_OPTIMIZE_TEXCUBELOD
        o.reflUVW = reflect(o.eyeVec, normalWorld);
#endif

        //o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        //o.tex = v.texcoord;
        o.screenUV = ComputeScreenPos(o.pos);
        o.tangent.xyz = mul((float3x3)unity_ObjectToWorld, v.tangent);
        o.tangent.w = v.tangent.w;
        o.normal = mul((float3x3)unity_ObjectToWorld, v.normal);
        o.eyeVec = NormalizePerVertexNormal(posWorld.xyz - _WorldSpaceCameraPos);

        return o;
    }


    void fragDecalDeferred(
        VertexOutputDeferredDecal i,
        out half4 outDiffuse : SV_Target0,			// RT0: diffuse color (rgb), occlusion (a)
        out half4 outSpecSmoothness : SV_Target1,	// RT1: spec color (rgb), smoothness (a)
        out half4 outNormal : SV_Target2,			// RT2: normal (rgb), --unused, very low precision-- (a) 
        out half4 outEmission : SV_Target3			// RT3: emission (rgb), --unused-- (a)
        )
    {

        float3 normal = normalize(i.normal);
        float4 tangent = i.tangent;
        tangent.xyz = normalize(tangent.xyz);
        float tangentSign = tangent.w * unity_WorldTransformParams.w;
        float3 binormal = cross(normal, tangent.xyz) * tangentSign;

        float2 screenUV = i.screenUV.xy / i.screenUV.w;

        float4 gBuffer0 = tex2D(_CameraGBufferTexture0DecalCopy, screenUV);
        float4 gBuffer1 = tex2D(_CameraGBufferTexture1DecalCopy, screenUV);
        float4 gBuffer2 = tex2D(_CameraGBufferTexture2DecalCopy, screenUV);
        float4 gBuffer3 = tex2D(_CameraGBufferTexture3DecalCopy, screenUV);

        outDiffuse = gBuffer0;
        outSpecSmoothness = gBuffer1;
        outNormal = gBuffer2;
        outEmission = gBuffer3;

        float3 backNormal = outNormal.xyz*2-1;

        float3 parallaxViewDir = IN_VIEWDIR4PARALLAX(i);// float3(i.tangentToWorldAndParallax[0].w, i.tangentToWorldAndParallax[1].w, i.tangentToWorldAndParallax[2].w);
        float4 heightSample = tex2D(_ParallaxMap, i.tex.xy);
        float2 uv = i.tex.xy+ParallaxOffset1Step(heightSample.r, _Parallax, parallaxViewDir);

        float4 colorSample = tex2D(_MainTex, uv);
        float4 metallicSmoothnessSample = tex2D(_MetallicGlossMap, uv);
        float4 occlusionSample = tex2D(_OcclusionMap, uv);
        float3 normalSample = UnpackNormal(tex2D(_BumpMap, uv));

        metallicSmoothnessSample.rgb *= _Metallic;
        metallicSmoothnessSample.a *= _Glossiness;
        occlusionSample = lerp(float4(1, 1, 1, 1), occlusionSample, _OcclusionStrength);

        float3 tSpace0 = float3(tangent.x, binormal.x, normal.x);
        float3 tSpace1 = float3(tangent.y, binormal.y, normal.y);
        float3 tSpace2 = float3(tangent.z, binormal.z, normal.z);

        float3 worldNormal = 0;
        worldNormal.x = dot(tSpace0, normalSample);
        worldNormal.y = dot(tSpace1, normalSample);
        worldNormal.z = dot(tSpace2, normalSample);

        //float facingAngle = saturate(dot(backNormal, i.orientation));
        float opacity = colorSample.a;

        half oneMinusReflectivity;
        half3 specColor;
        half3 diffColor = DiffuseAndSpecularFromMetallic(colorSample.rgb, metallicSmoothnessSample.r, specColor, oneMinusReflectivity);

		diffColor = lerp(outDiffuse.rgb, diffColor, opacity*_DiffuseStrength);
		specColor = lerp(outSpecSmoothness.rgb, specColor, opacity*_SpecularStrength);
		metallicSmoothnessSample.a = lerp(outSpecSmoothness.a, metallicSmoothnessSample.a, opacity*_SmoothnessStrength);
		worldNormal = lerp(outNormal*2-1, worldNormal, opacity*_NormalStrength);
		//outEmission.rgb = lerp(outEmission.rgb*occlusionSample.r, color, opacity);

#if (SHADER_TARGET < 30)
        outDiffuse = 1;
        outSpecSmoothness = 1;
        outNormal = 0;
        outEmission = 0;
        return;
#endif

        FRAGMENT_SETUP(s)
#if UNITY_OPTIMIZE_TEXCUBELOD
            s.reflUVW = i.reflUVW;
#endif

        s.diffColor = diffColor;
        s.specColor = specColor;
        s.oneMinusReflectivity = oneMinusReflectivity;
        s.oneMinusRoughness = metallicSmoothnessSample.a;
        s.normalWorld = worldNormal;

        // no analytic lights in this pass
        UnityLight dummyLight = DummyLight(s.normalWorld);
        half atten = 1;

        // only GI
        half occlusion = Occlusion(i.tex.xy);
#if UNITY_ENABLE_REFLECTION_BUFFERS
        bool sampleReflectionsInDeferred = false;
#else
        bool sampleReflectionsInDeferred = true;
#endif

        UnityGI gi = FragmentGI(s, occlusion, i.ambientOrLightmapUV, atten, dummyLight, sampleReflectionsInDeferred);

        half3 color = UNITY_BRDF_PBS(s.diffColor, s.specColor, s.oneMinusReflectivity, s.oneMinusRoughness, s.normalWorld, -s.eyeVec, gi.light, gi.indirect).rgb;
        color += UNITY_BRDF_GI(s.diffColor, s.specColor, s.oneMinusReflectivity, s.oneMinusRoughness, s.normalWorld, -s.eyeVec, occlusion, gi);

#ifdef _EMISSION
        color += Emission(i.tex.xy);
#endif

#ifndef UNITY_HDR_ON
        color.rgb = exp2(-color.rgb);
#endif

        //outDiffuse = half4(s.diffColor, occlusion);
        //outSpecSmoothness = half4(s.specColor, s.oneMinusRoughness);
        //outNormal = half4(s.normalWorld*0.5+0.5, 1);
        //outEmission = half4(color, 1);

		outDiffuse.rgb = diffColor;
		outDiffuse.a = lerp(outDiffuse.a, occlusionSample.r, opacity);
		outDiffuse.a *= lerp(occlusionSample.r, 1, opacity);
		outSpecSmoothness.rgb = specColor;
		outSpecSmoothness.a = metallicSmoothnessSample.a;
		outNormal.rgb = worldNormal*0.5+0.5;
		outEmission.rgb = lerp(outEmission.rgb*occlusionSample.r, color, opacity);

		/*
        outDiffuse.rgb = lerp(outDiffuse.rgb, diffColor.rgb, opacity*_DiffuseStrength);
        outDiffuse.a = lerp(outDiffuse.a, occlusionSample.r, opacity);
        outDiffuse.a *= lerp(occlusionSample.r, 1, opacity);
        outSpecSmoothness.rgb = lerp(outSpecSmoothness.rgb, specColor, opacity*_SpecularStrength);
        outSpecSmoothness.a = lerp(outSpecSmoothness.a, metallicSmoothnessSample.a, opacity*_SmoothnessStrength);
        outNormal.rgb = lerp(outNormal, worldNormal*0.5+0.5, opacity*_NormalStrength);
        outEmission.rgb = lerp(outEmission.rgb*occlusionSample.r, color, opacity);
		*/
    }

        ENDCG
    }

    Pass
    {
        Name "UPDATEGBUFFER"

        CGPROGRAM
#pragma target 3.0

#pragma vertex vertDecalDeferred
#pragma fragment fragDecalDeferred

#include "UnityCG.cginc"

    struct V2F
    {
        float4 pos : SV_POSITION;
        float4 screenUV : TEXCOORD0;
    };

    sampler2D _CameraGBufferTexture0;
    sampler2D _CameraGBufferTexture1;
    sampler2D _CameraGBufferTexture2;
    sampler2D _CameraGBufferTexture3;

    V2F vertDecalDeferred(appdata_full v)
    {
        V2F o;
        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.screenUV = ComputeScreenPos(o.pos);
        return o;
    }


    void fragDecalDeferred(
        V2F i,
        out half4 outDiffuse : SV_Target0,			// RT0: diffuse color (rgb), occlusion (a)
        out half4 outSpecSmoothness : SV_Target1,	// RT1: spec color (rgb), smoothness (a)
        out half4 outNormal : SV_Target2,			// RT2: normal (rgb), --unused, very low precision-- (a) 
        out half4 outEmission : SV_Target3			// RT3: emission (rgb), --unused-- (a)
        )
    {
        float2 screenUV = i.screenUV.xy / i.screenUV.w;

        float4 gBuffer0 = tex2D(_CameraGBufferTexture0, screenUV);
        float4 gBuffer1 = tex2D(_CameraGBufferTexture1, screenUV);
        float4 gBuffer2 = tex2D(_CameraGBufferTexture2, screenUV);
        float4 gBuffer3 = tex2D(_CameraGBufferTexture3, screenUV);

        outDiffuse = gBuffer0;
        outSpecSmoothness = gBuffer1;
        outNormal = gBuffer2;
        outEmission = gBuffer3;
    }

    ENDCG
    }
    }
}