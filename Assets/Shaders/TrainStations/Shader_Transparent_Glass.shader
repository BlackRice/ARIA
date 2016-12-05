//#EditorFriendly
//#node24:posx=-123:posy=-63.5:title=Lerp:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=23:input0linkindexoutput=0:input1=(0,0,0,0):input1type=Vector4:input1linkindexnode=1:input1linkindexoutput=0:input2=1:input2type=float:
//#node23:posx=-303:posy=-120.5:title=Texture:title2=mainTex:input0=(0,0):input0type=Vector2:
//#node22:posx=-334:posy=-12.5:title=Divide:input0=1:input0type=float:input0linkindexnode=18:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=21:input1linkindexoutput=0:
//#node21:posx=-493:posy=-84.5:title=Vector.Z:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=20:input0linkindexoutput=0:
//#node20:posx=-607:posy=-88.5:title=ScreenPos:
//#node19:posx=-483:posy=166.5:title=Multiply:input0=0.575:input0type=float:input1=1:input1type=float:input1linkindexnode=3:input1linkindexoutput=0:
//#node18:posx=-403:posy=61.5:title=Add:input0=0:input0type=float:input0linkindexnode=2:input0linkindexoutput=0:input1=0:input1type=float:input1linkindexnode=19:input1linkindexoutput=0:
//#node17:posx=-701:posy=37.5:title=Normalize:input0=0:input0type=float:input0linkindexnode=15:input0linkindexoutput=0:
//#node16:posx=-587:posy=-8:title=Vector.XY:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=17:input0linkindexoutput=0:
//#node15:posx=-749:posy=-60:title=UnpackNormal:input0=0:input0type=float:input0linkindexnode=6:input0linkindexoutput=0:
//#node14:posx=0:posy=0:title=Lighting:title2=On:
//#node13:posx=0:posy=0:title=DoubleSided:title2=Off:
//#node12:posx=0:posy=0:title=FallbackInfo:title2=Transparent/Cutout/VertexLit:input0=1:input0type=float:
//#node11:posx=0:posy=0:title=LODInfo:title2=LODInfo1:input0=500:input0type=float:
//#node10:posx=-278.5:posy=104.5:title=ParamFloat:title2=SpecPower:input0=1:input0type=float:
//#node9:posx=-163.5:posy=100.5:title=ParamFloat:title2=Glossiness:input0=1:input0type=float:
//#node8:posx=-948.5:posy=120.5:title=ParamFloat:title2=UVScale:input0=1:input0type=float:
//#node7:posx=-835.5:posy=77.5:title=Multiply:input0=1:input0type=float:input0linkindexnode=5:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=8:input1linkindexoutput=0:
//#node6:posx=-850.5:posy=-41.5:title=NormalMap:input0=(0,0):input0type=Vector2:input0linkindexnode=7:input0linkindexoutput=0:
//#node5:posx=-943.5:posy=16.5:title=UV1:
//#node4:posx=-142.5:posy=17.5:title=Multiply:input0=1:input0type=float:input0linkindexnode=1:input0linkindexoutput=0:input1=0.5:input1type=float:
//#node3:posx=-626.5:posy=175.5:title=ParamFloat:title2=Refraction:input0=1:input0type=float:
//#node2:posx=-518.5:posy=56.5:title=Multiply:input0=1:input0type=float:input0linkindexnode=16:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=3:input1linkindexoutput=0:
//#node1:posx=-234.5:posy=-32.5:title=SceneColor:input0=(0,0):input0type=Vector2:input0linkindexnode=22:input0linkindexoutput=0:
//#masterNode:posx=0:posy=0:title=Master Node:input0linkindexnode=24:input0linkindexoutput=0:input1linkindexnode=24:input1linkindexoutput=0:input2linkindexnode=10:input2linkindexoutput=0:input3linkindexnode=9:input3linkindexoutput=0:input5linkindexnode=17:input5linkindexoutput=0:
//#sm=3.0
//#blending=Alpha
//#ShaderName
Shader "ShaderFusion/Shader_Transparent_Glass" {
	Properties {
_Color ("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
_SpecColor ("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
//#ShaderProperties
_mainTex ("mainTex", 2D) = "white" {}
_UVScale ("UVScale", Float) = 1
_BumpMap ("Normal Map", 2D) = "white" {}
_Refraction ("Refraction", Float) = 1
_SpecPower ("SpecPower", Float) = 1
_Glossiness ("Glossiness", Float) = 1
	}
	Category {
		SubShader { 
//#Blend
ZWrite Off
Blend SrcAlpha OneMinusSrcAlpha
//#CatTags
Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
Lighting On
Cull Off
//#LOD
LOD 500
//#GrabPass
GrabPass { }
		CGPROGRAM
//#LightingModelTag
#pragma surface surf ShaderFusion vertex:vert exclude_path:prepass fullforwardshadows novertexlights
float _ProbeMultiplyer;
struct SurfaceShaderFusion {
    half3 Albedo;
    half3 Normal;
    half3 Emission;
    half Specular;
    half3 GlossColor;
    half Alpha;
};
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
	
inline fixed4 LightingShaderFusion(SurfaceShaderFusion s, fixed3 lightDir, half3 viewDir, fixed atten)
{
	half4 probeNormal = half4(s.Normal.x, s.Normal.y, s.Normal.z, 1.0f);
	float3 probeColor;
	probeColor = CustomShadeSH9(probeNormal)*custom_unity_SHMask;
	//probeColor = _unity_SHAr;
	
	half3 h = normalize (lightDir + viewDir);
	
	fixed diff = max (0, dot (s.Normal, lightDir));
	
	float nh = max (0, dot (s.Normal, h));
	float3 spec = s.GlossColor*pow(nh, s.Specular*128.0);
	
	fixed4 c;
	c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * _SpecColor.rgb * spec) * (atten * 2);
	c.rgb += probeColor*s.Albedo;
	c.a = s.Alpha + _LightColor0.a * _SpecColor.a * spec * atten;
	//c.a = _LightColor0.a * _SpecColor.a * spec * atten;
	return c;
}
inline fixed4 LightingShaderFusion_PrePass(SurfaceShaderFusion s, half4 light) {
	half4 probeNormal = half4(s.Normal.x, s.Normal.y, s.Normal.z, 1.0f);
	float3 probeColor;
	probeColor = CustomShadeSH9(probeNormal)*custom_unity_SHMask;
	
	fixed spec = light.a * s.GlossColor;
	
	fixed4 c;
	c.rgb = (s.Albedo * light.rgb + light.rgb * _SpecColor.rgb * spec);
	c.rgb += (probeColor*s.Albedo);
	//c.a = s.Alpha + spec * _SpecColor.a;
	c.a = s.Alpha;
	return c;
}
inline half4 LightingShaderFusion_DirLightmap(SurfaceShaderFusion s, fixed4 color, fixed4 scale, half3 viewDir, bool surfFuncWritesNormal, out half3 specColor)
{
	UNITY_DIRBASIS
	half3 scalePerBasisVector;
	
	half3 lm = DirLightmapDiffuse (unity_DirBasis, color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
	half3 lightDir = normalize (scalePerBasisVector.x * unity_DirBasis[0] + scalePerBasisVector.y * unity_DirBasis[1] + scalePerBasisVector.z * unity_DirBasis[2]);
	half3 h = normalize (lightDir + viewDir);
	float nh = max (0, dot (s.Normal, h));
	float spec = pow (nh, s.Specular * 128.0);
	
	// specColor used outside in the forward path, compiled out in prepass
	specColor = lm * _SpecColor.rgb * s.GlossColor * spec;
	
	// spec from the alpha component is used to calculate specular
	// in the Lighting*_Prepass function, it's not used in forward
	return half4(lm, spec);
}
//#TargetSM
#pragma target 3.0
//#UnlitCGDefs
sampler2D _mainTex;
float _UVScale;
sampler2D _BumpMap;
float _Refraction;
sampler2D _GrabTexture;
float4 _GrabTexture_TexelSize;
float _SpecPower;
float _Glossiness;
float4 _Color;
		struct Input {
//#UVDefs
float4 sfuv1;
float2 uvCoords;
float4 screenPos;
		INTERNAL_DATA
		};
		
		void vert (inout appdata_full v, out Input o) {
UNITY_INITIALIZE_OUTPUT(Input, o);
//#DeferredVertexBody
o.sfuv1.xy = v.texcoord.xy;
//#DeferredVertexEnd
		}
		void surf (Input IN, inout SurfaceShaderFusion o) {
			float4 normal = float4(0.0,0.0,1.0,0.0);
			float3 emissive = 0.0;
			float3 specular = 1.0;
			float gloss = 1.0;
			float3 diffuse = 1.0;
			float alpha = 1.0;
//#PreFragBody
float4 node23 = tex2D(_mainTex,IN.sfuv1.xy);
float4 node6 = (float4(UnpackNormal(tex2D(_BumpMap,((IN.sfuv1.xy) * (_UVScale)))),0));
float4 __sceneColor_node1 = (tex2D(_GrabTexture,((IN.screenPos.xy/IN.screenPos.w)+(((((((normalize((float4(float3(UnpackNormal((node6))),0)))).xy) * (_Refraction)) + (0.575 * (_Refraction))) / ((IN.screenPos).z)))*(IN.screenPos.z*_GrabTexture_TexelSize.xy)))));
//#FragBody
normal = (normalize((float4(float3(UnpackNormal((node6))),0))));
gloss = (_Glossiness);
specular = (_SpecPower);
emissive = (lerp((node23),(__sceneColor_node1),1));
diffuse = (lerp((node23),(__sceneColor_node1),1));
			
			o.Albedo = diffuse.rgb*_Color;
			#ifdef SHADER_API_OPENGL
			o.Albedo = max(float3(0,0,0),o.Albedo);
			#endif
			
			o.Emission = emissive*_Color;
			#ifdef SHADER_API_OPENGL
			o.Emission = max(float3(0,0,0),o.Emission);
			#endif
			
			o.GlossColor = specular*_SpecColor;
			#ifdef SHADER_API_OPENGL
			o.GlossColor = max(float3(0,0,0),o.GlossColor);
			#endif
			
			o.Alpha = alpha*_Color.a;
			#ifdef SHADER_API_OPENGL
			o.Alpha = max(float3(0,0,0),o.Alpha);
			#endif
			
			o.Specular = gloss;
			#ifdef SHADER_API_OPENGL
			o.Specular = max(float3(0,0,0),o.Specular);
			#endif
			
			o.Normal = normal;
//#FragEnd
		}
		ENDCG
		}
	}
//#Fallback
Fallback "Transparent/Cutout/VertexLit"
}
