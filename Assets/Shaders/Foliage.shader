// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Foliage"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_MaskClipValue( "Mask Clip Value", Float ) = 0.5
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[Header(Translucency)]
		_Translucency("Strength", Range( 0 , 50)) = 1
		_TransNormalDistortion("Normal Distortion", Range( 0 , 1)) = 0.1
		_TransScattering("Scaterring Falloff", Range( 1 , 50)) = 2
		_TransDirect("Direct", Range( 0 , 1)) = 1
		_TransAmbient("Ambient", Range( 0 , 1)) = 0.2
		_TransShadow("Shadow", Range( 0 , 1)) = 0.9
		_WindNormals("WindNormals", 2D) = "bump" {}
		_WindStrength("WindStrength", Float) = 1
		_WindSpeed("WindSpeed", Vector) = (0.01,0.01,0,0)
		_WindScale("WindScale", Float) = 10
		_Normals("Normals", 2D) = "bump" {}
		_Color("Color", Color) = (0.5483832,0.7058823,0.1868512,1)
		_TranslucencyTexture("TranslucencyTexture", 2D) = "white" {}
		_SmoothnessTexture("SmoothnessTexture", 2D) = "white" {}
		_MainTex("MainTex", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma surface surf StandardCustom keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 texcoord_0;
			float2 uv_texcoord;
		};

		struct SurfaceOutputStandardCustom
		{
			fixed3 Albedo;
			fixed3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			fixed Alpha;
			fixed3 Translucency;
		};

		uniform sampler2D _Normals;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _SmoothnessTexture;
		uniform float4 _SmoothnessTexture_ST;
		uniform float _Smoothness;
		uniform half _Translucency;
		uniform half _TransNormalDistortion;
		uniform half _TransScattering;
		uniform half _TransDirect;
		uniform half _TransAmbient;
		uniform half _TransShadow;
		uniform sampler2D _TranslucencyTexture;
		uniform float4 _TranslucencyTexture_ST;
		uniform sampler2D _WindNormals;
		uniform float _WindScale;
		uniform float2 _WindSpeed;
		uniform float _WindStrength;
		uniform float _MaskClipValue = 0.5;

		UNITY_INSTANCING_CBUFFER_START(Foliage)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Color)
		UNITY_INSTANCING_CBUFFER_END

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.texcoord_0.xy = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
			float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex);
			float2 appendResult36 = (float2(ase_worldPos.x , ase_worldPos.z));
			float3 tex2DNode29 = UnpackNormal( tex2Dlod( _WindNormals, float4( ( ( appendResult36 / _WindScale ) + ( _WindSpeed * _Time.y ) ), 0.0 , 0.0 ) ) );
			float3 appendResult30 = (float3(tex2DNode29.r , 0.0 , tex2DNode29.g));
			float4 appendResult24 = (float4(( appendResult30 * _WindStrength ).x , 0.0 , 0.0 , 0.0));
			v.vertex.xyz += mul( unity_WorldToObject , appendResult24 ).xyz;
		}

		inline half4 LightingStandardCustom(SurfaceOutputStandardCustom s, half3 viewDir, UnityGI gi )
		{
			#if !DIRECTIONAL
			float3 lightAtten = gi.light.color;
			#else
			float3 lightAtten = lerp( _LightColor0, gi.light.color, _TransShadow );
			#endif
			half3 lightDir = gi.light.dir + s.Normal * _TransNormalDistortion;
			half transVdotL = pow( saturate( dot( viewDir, -lightDir ) ), _TransScattering );
			half3 translucency = lightAtten * (transVdotL * _TransDirect + gi.indirect.diffuse * _TransAmbient) * s.Translucency;
			half4 c = half4( s.Albedo * translucency * _Translucency, 0 );

			SurfaceOutputStandard r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Metallic = s.Metallic;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandard (r, viewDir, gi) + c;
		}

		inline void LightingStandardCustom_GI(SurfaceOutputStandardCustom s, UnityGIInput data, inout UnityGI gi )
		{
			UNITY_GI(gi, s, data);
		}

		void surf( Input i , inout SurfaceOutputStandardCustom o )
		{
			o.Normal = UnpackNormal( tex2D( _Normals, i.texcoord_0 ) );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode4 = tex2D( _MainTex, uv_MainTex );
			float4 _Color_Instance = UNITY_ACCESS_INSTANCED_PROP(_Color);
			o.Albedo = ( tex2DNode4 * _Color_Instance ).rgb;
			o.Metallic = 0.0;
			float2 uv_SmoothnessTexture = i.uv_texcoord * _SmoothnessTexture_ST.xy + _SmoothnessTexture_ST.zw;
			o.Smoothness = ( tex2D( _SmoothnessTexture, uv_SmoothnessTexture ).r * _Smoothness );
			float2 uv_TranslucencyTexture = i.uv_texcoord * _TranslucencyTexture_ST.xy + _TranslucencyTexture_ST.zw;
			o.Translucency = tex2D( _TranslucencyTexture, uv_TranslucencyTexture ).rgb;
			o.Alpha = 1;
			clip( tex2DNode4.a - _MaskClipValue );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=12101
258;415;1367;582;2870.509;-183.5702;2.2;True;True
Node;AmplifyShaderEditor.WorldPosInputsNode;35;-2071.509,687.4703;Float;False;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;39;-1742.81,1029.47;Float;False;1;0;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;36;-1835.909,714.0701;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.RangedFloatNode;38;-1963.209,875.5703;Float;False;Property;_WindScale;WindScale;12;0;10;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.Vector2Node;40;-1750.409,881.2703;Float;False;Property;_WindSpeed;WindSpeed;11;0;0.01,0.01;0;3;FLOAT2;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-1514.809,894.5701;Float;False;2;2;0;FLOAT2;0.0;False;1;FLOAT;0.0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleDivideOpNode;43;-1607.909,651.3702;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT;0.0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-1374.209,799.5701;Float;False;2;2;0;FLOAT2;0.0;False;1;FLOAT2;0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.SamplerNode;29;-1237.809,733.2502;Float;True;Property;_WindNormals;WindNormals;9;0;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;32;-897.4089,971.5502;Float;False;Property;_WindStrength;WindStrength;10;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;30;-911.009,757.9501;Float;False;FLOAT3;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-716.9089,751.1501;Float;False;2;2;0;FLOAT3;0.0;False;1;FLOAT;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.BreakToComponentsNode;28;-456.509,746.3503;Float;False;FLOAT3;1;0;FLOAT3;0.0;False;16;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.WorldToObjectMatrix;21;-259.9094,688.9502;Float;False;0;1;FLOAT4x4
Node;AmplifyShaderEditor.SamplerNode;4;-823.0298,-236.2248;Float;True;Property;_MainTex;MainTex;17;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;24;-179.5094,772.3502;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-1485.98,270.575;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ColorNode;5;-790.4799,-36.72489;Float;False;InstancedProperty;_Color;Color;14;0;0.5483832,0.7058823,0.1868512,1;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;9;-760.3797,256.3752;Float;True;Property;_SmoothnessTexture;SmoothnessTexture;16;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;12;-694.0798,441.775;Float;False;Property;_Smoothness;Smoothness;1;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-2.309319,695.9503;Float;False;2;2;0;FLOAT4x4;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT4;0.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-474.5799,-129.8748;Float;False;2;2;0;COLOR;0.0;False;1;COLOR;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SamplerNode;16;-1151.58,136.175;Float;True;Property;_Normals;Normals;13;0;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;10;-201.9798,223.175;Float;False;Constant;_Float1;Float 1;0;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;14;-279.3799,449.4084;Float;True;Property;_TranslucencyTexture;TranslucencyTexture;15;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-337.0797,278.7751;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;280,307;Float;False;True;2;Float;ASEMaterialInspector;0;Standard;Foliage;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Back;0;0;False;0;0;Masked;0.5;True;True;0;False;TransparentCutout;AlphaTest;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;0;2;-1;-1;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;36;0;35;1
WireConnection;36;1;35;3
WireConnection;41;0;40;0
WireConnection;41;1;39;0
WireConnection;43;0;36;0
WireConnection;43;1;38;0
WireConnection;42;0;43;0
WireConnection;42;1;41;0
WireConnection;29;1;42;0
WireConnection;30;0;29;1
WireConnection;30;2;29;2
WireConnection;31;0;30;0
WireConnection;31;1;32;0
WireConnection;28;0;31;0
WireConnection;24;0;28;0
WireConnection;22;0;21;0
WireConnection;22;1;24;0
WireConnection;6;0;4;0
WireConnection;6;1;5;0
WireConnection;16;1;17;0
WireConnection;11;0;9;1
WireConnection;11;1;12;0
WireConnection;0;0;6;0
WireConnection;0;1;16;0
WireConnection;0;3;10;0
WireConnection;0;4;11;0
WireConnection;0;7;14;0
WireConnection;0;10;4;4
WireConnection;0;11;22;0
ASEEND*/
//CHKSM=1F59B11F0E7CB97307D3078DE9EA98AF98599EE0