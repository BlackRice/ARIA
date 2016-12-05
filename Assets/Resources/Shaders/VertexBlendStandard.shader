Shader "Custom/VertexBlendStandard" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_BumpMap("Normal", 2D) = "normal" {}
		_MetallicSmoothness("MetallicSmoothness", 2D) = "black" {}
		_Height("Height", 2D) = "Black" {}
		_Glossiness("Smoothness", Range(0,1)) = 1
		_Metallic("Metallic", Range(0,1)) = 1

		_MainTex2("MainTex2", 2D) = "white" {}
		_BumpMap2("Normal2", 2D) = "normal" {}
		_MetallicSmoothness2("MetallicSmoothness2", 2D) = "black" {}
		_Height2("Heigh2t", 2D) = "Black" {}
		_Glossiness2("Smoothness2", Range(0,1)) = 1
		_Metallic2("Metallic2", Range(0,1)) = 1

		_TestBlendValue("TestBlendValue", Range(0, 1)) = 0.5
		_BlendContrast("BlendContrast", Range(0, 1)) = 0.5
		_VertexBlendStrength("VertexBlendStrength", Float) = 1
		_VertexBlendContrast("VertexBlendContrast", Float) = 1

		_DarkenAmountShift("DarkenAmountShift", Range(0, 1)) = 1
		_DarkenContrast("DarkenContrast", Range(0, 1)) = 1
		_DarkenColor("DarkenColor", Color) = (1,1,1,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows vertex:vert
		#pragma target 3.0

		struct Input {
			float2 uv_MainTex;
			float4 color;
		};

		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _MetallicSmoothness;
		sampler2D _Height;
		float _Glossiness;
		float _Metallic;

		sampler2D _MainTex2;
		sampler2D _BumpMap2;
		sampler2D _MetallicSmoothness2;
		sampler2D _Height2;
		float _Glossiness2;
		float _Metallic2;

		float _TestBlendValue;
		float _BlendContrast;
		float _VertexBlendStrength;
		float _VertexBlendContrast;
		float _DarkenAmountShift;
		float _DarkenContrast;
		float4 _DarkenColor;
		

		void vert(inout appdata_full v, out Input o) {
			UNITY_INITIALIZE_OUTPUT(Input, o);
			o.color = v.color;
		}

		void surf(Input IN, inout SurfaceOutputStandard o) {
			float4 mainTexSample = tex2D(_MainTex, IN.uv_MainTex);
			float3 normalSample = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
			float2 metallicSmoothnessSample = tex2D(_MetallicSmoothness, IN.uv_MainTex).ra*float2(_Metallic, _Glossiness);
			float heightSample = tex2D(_Height, IN.uv_MainTex).r;

			float4 mainTexSample2 = tex2D(_MainTex2, IN.uv_MainTex);
			float3 normalSample2 = UnpackNormal(tex2D(_BumpMap2, IN.uv_MainTex));
			float2 metallicSmoothnessSample2 = tex2D(_MetallicSmoothness2, IN.uv_MainTex).ra*float2(_Metallic2, _Glossiness2);
			float heightSample2 = tex2D(_Height2, IN.uv_MainTex).r;

			float vBlend = 1.0-IN.color.r;
			vBlend *= _VertexBlendStrength;
			vBlend = pow(vBlend, _VertexBlendContrast);
			//vBlend = _TestBlendValue;

			float blendFactor = saturate((heightSample-(vBlend-1))-(heightSample2+ (vBlend - 0.5)));
			blendFactor -= 0.5;
			blendFactor /= _BlendContrast;
			blendFactor += 0.5;
			blendFactor = saturate(blendFactor);

			float darkenMask = 1.0-(abs(blendFactor-0.5)*2);
			darkenMask *= _DarkenAmountShift;
			darkenMask -= 0.5;
			darkenMask /= _DarkenContrast*_DarkenAmountShift;
			darkenMask += 0.5;
			darkenMask = saturate(darkenMask);

			float3 diffuse = lerp(mainTexSample.rgb, mainTexSample2.rgb, blendFactor);
			float3 normal = lerp(normalSample.rgb, normalSample2.rgb, blendFactor);
			float metallic = lerp(metallicSmoothnessSample.r, metallicSmoothnessSample2.r, blendFactor);
			float smoothness = lerp(metallicSmoothnessSample.g, metallicSmoothnessSample2.g, blendFactor);

			diffuse = lerp(diffuse, diffuse*_DarkenColor.rgb, darkenMask);

			o.Albedo = diffuse;
			o.Emission = 0;
			o.Normal = normal;
			o.Metallic = metallic;
			o.Smoothness = smoothness;

			/*
			o.Albedo = 0;
			o.Emission = darkenMask;
			o.Metallic = 0;
			o.Smoothness = 0;
			*/
		}
		ENDCG
	}
}
