Shader "Custom/Curtain" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		
	
			Tags { "RenderType"="Opaque" }
			LOD 200
			CGPROGRAM
			//exclude_path:prepass 
			#pragma surface surf SSS exclude_path:prepass vertex:vert novertexlights
			#pragma target 3.0
			float _ProbeMultiplyer;
			struct SurfaceColorSpec {
			    half3 Albedo;
			    half3 Normal;
			    half3 Emission;
			    half Specular;
			    half3 GlossColor;
			    half Alpha;
			};
			
				
			inline fixed4 LightingSSS(SurfaceColorSpec s, fixed3 lightDir, half3 viewDir, fixed atten)
			{
				half3 h = normalize (lightDir + viewDir);
				
				fixed diff = max (0, dot (s.Normal, lightDir));
				
				float nh = max (0, dot (s.Normal, h));
				float3 spec = s.GlossColor*pow(nh, s.Specular*128.0);
				
				fixed4 c;
				c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * _SpecColor.rgb * spec) * (atten * 2);
				
				c.a = s.Alpha + _LightColor0.a * _SpecColor.a * spec * atten;
				
				return c;
			}
			inline fixed4 LightingSSS_PrePass(SurfaceColorSpec s, half4 light) {
				return 0;
			}
			inline half4 LightingSSS_DirLightmap(SurfaceColorSpec s, fixed4 color, fixed4 scale, half3 viewDir, bool surfFuncWritesNormal, out half3 specColor)
			{
				return 0;
			}
	
			sampler2D _MainTex;
			float4 _Color;
			struct Input {
				float2 uv_MainTex;
			};
			
			void vert (inout appdata_full v, out Input o) {
				UNITY_INITIALIZE_OUTPUT(Input, o);
			}
			
			void surf (Input IN, inout SurfaceColorSpec o) {
				half4 difuseSample = tex2D(_MainTex, IN.uv_MainTex);
				float4 color = difuseSample*_Color;
				o.Albedo = color.rgb;
				o.Alpha = color.a;
			}
			ENDCG
	

	}
	FallBack "Diffuse"
}
