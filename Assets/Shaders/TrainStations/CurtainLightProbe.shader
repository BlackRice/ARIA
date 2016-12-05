// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/CurtainLightProbe" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Transparent"}
		LOD 200
		Pass {
			Blend One One
			ZWrite Off
			//ZTest Off
			Offset -1,-1
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members wNormal)
#pragma exclude_renderers d3d11 xbox360
			// Upgrade NOTE: excluded shader from Xbox360; has structs without semantics (struct v2f members wNormal)
			#pragma exclude_renderers xbox360
			
			float _ProbeMultiplyer;
			
			float4 custom_unity_SHAr;
			float4 custom_unity_SHAg;
			float4 custom_unity_SHAb;
			float4 custom_unity_SHBr;
			float4 custom_unity_SHBg;
			float4 custom_unity_SHBb;
			float4 custom_unity_SHC;
			float custom_unity_SHMask;
			// normal should be normalized, w=1.0
			half3 CustomShadeSH9 (half4 normal)
			{
				half3 x1, x2, x3;
				
				// Linear + constant polynomial terms
				x1.r = dot(custom_unity_SHAr,normal);
				x1.g = dot(custom_unity_SHAg,normal);
				x1.b = dot(custom_unity_SHAb,normal);
				
				// 4 of the quadratic polynomials
				half4 vB = normal.xyzz * normal.yzzx;
				x2.r = dot(custom_unity_SHBr,vB);
				x2.g = dot(custom_unity_SHBg,vB);
				x2.b = dot(custom_unity_SHBb,vB);
				
				// Final quadratic polynomial
				float vC = normal.x*normal.x - normal.y*normal.y;
				x3 = custom_unity_SHC.rgb * vC;
			    return x1 + x2 + x3;
			} 
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
	
			struct v2f {
				float4 pos:SV_POSITION;
				float3 wNormal;
			};
			
			v2f vert(appdata_full v)
			{
				v2f o;
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
				o.wNormal = normalize(mul((float3x3)unity_ObjectToWorld, v.normal));
				return o;
			}
			
			fixed4 frag(v2f i):COLOR0 {
				half4 probeNormal = half4(i.wNormal.x, i.wNormal.y, i.wNormal.z, 1.0f);
				float3 probeColor;
				probeColor = CustomShadeSH9(probeNormal)*custom_unity_SHMask;
				return float4(1,0,0,1);
				return float4((probeColor*1),1);
			}
			
			ENDCG
		}
	}
	FallBack "Diffuse"
}
