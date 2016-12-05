//#EditorFriendly
//#node29:posx=-705:posy=-102:title=Vector.Y:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=20:input0linkindexoutput=0:
//#node28:posx=-463:posy=-224:title=UV1:
//#node27:posx=-353:posy=-289:title=Multiply:input0=1:input0type=float:input0linkindexnode=26:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=28:input1linkindexoutput=0:
//#node26:posx=-463:posy=-295:title=ParamVector:title2=UV_Tiling:input0=(1,1,1,1):input0type=Vector4:
//#node25:posx=-162:posy=-211:title=ParamFloat:title2=MainBrightness_Add:input0=0:input0type=float:
//#node24:posx=-53:posy=-140:title=Add:input0=0:input0type=float:input0linkindexnode=25:input0linkindexoutput=0:input1=0:input1type=float:input1linkindexnode=12:input1linkindexoutput=0:
//#node23:posx=-705:posy=-174.5:title=Vector.Z:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=20:input0linkindexoutput=0:
//#node22:posx=-707:posy=-244.5:title=Vector.X:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=20:input0linkindexoutput=0:
//#node21:posx=-602:posy=-202.5:title=Assembler:input0=1:input0type=float:input0linkindexnode=22:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=23:input1linkindexoutput=0:input2=1:input2type=float:input2linkindexnode=29:input2linkindexoutput=0:input3=1:input3type=float:
//#node20:posx=-836:posy=-197.5:title=Position:
//#node19:posx=-345:posy=-26.5:title=ParamFloat:title2=OverlayAdd:input0=0:input0type=float:
//#node18:posx=-254:posy=-77.5:title=Add:input0=0:input0type=float:input0linkindexnode=14:input0linkindexoutput=0:input1=0:input1type=float:input1linkindexnode=19:input1linkindexoutput=0:
//#node17:posx=-713:posy=-6.5:title=ParamVector:title2=OverlayTile:input0=(0.25,0.25,1,1):input0type=Vector4:
//#node16:posx=-604:posy=-70.5:title=Multiply:input0=1:input0type=float:input0linkindexnode=21:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=17:input1linkindexoutput=0:
//#node15:posx=-480:posy=-19.5:title=ParamFloat:title2=OverlayBrightness:input0=2:input0type=float:
//#node14:posx=-371:posy=-102.5:title=Multiply:input0=1:input0type=float:input0linkindexnode=13:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=15:input1linkindexoutput=0:
//#node13:posx=-500:posy=-105.5:title=Texture:title2=OverlayTex:input0=(0,0):input0type=Vector2:input0linkindexnode=16:input0linkindexoutput=0:
//#node12:posx=-162:posy=-113.5:title=Multiply:input0=1:input0type=float:input0linkindexnode=5:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=18:input1linkindexoutput=0:
//#node11:posx=-185:posy=124.5:title=ParamFloat:title2=Glossiness:input0=0.4:input0type=float:
//#node10:posx=-287:posy=119.5:title=ParamFloat:title2=SpecPower:input0=1:input0type=float:
//#node9:posx=-170:posy=54.5:title=Multiply:input0=1:input0type=float:input0linkindexnode=8:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=10:input1linkindexoutput=0:
//#node8:posx=-292:posy=54.5:title=Texture:title2=Specular:input0=(0,0):input0type=Vector2:
//#node7:posx=-237:posy=195.5:title=UnpackNormal:input0=0:input0type=float:input0linkindexnode=6:input0linkindexoutput=0:
//#node6:posx=-343:posy=195.5:title=Texture:title2=Bumpmap:input0=(0,0):input0type=Vector2:input0linkindexnode=27:input0linkindexoutput=0:
//#node5:posx=-313:posy=-190.5:title=Texture:title2=MainTex:input0=(0,0):input0type=Vector2:input0linkindexnode=27:input0linkindexoutput=0:
//#node4:posx=0:posy=0:title=Lighting:title2=On:
//#node3:posx=0:posy=0:title=DoubleSided:title2=Back:
//#node2:posx=0:posy=0:title=FallbackInfo:title2=Transparent/Cutout/VertexLit:input0=1:input0type=float:
//#node1:posx=0:posy=0:title=LODInfo:title2=LODInfo1:input0=600:input0type=float:
//#masterNode:posx=0:posy=0:title=Master Node:input0linkindexnode=24:input0linkindexoutput=0:input2linkindexnode=9:input2linkindexoutput=0:input3linkindexnode=11:input3linkindexoutput=0:input5linkindexnode=7:input5linkindexoutput=0:
//#sm=3.0
//#blending=Normal
//#ShaderName
Shader "ShaderFusion/RoofTilesOverlay" {
	Properties {
_Color ("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
_SpecColor ("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
//#ShaderProperties
_MainBrightness_Add ("MainBrightness_Add", Float) = 0
_UV_Tiling ("UV_Tiling", Vector) = (1,1,1,1)
_MainTex ("MainTex", 2D) = "white" {}
_OverlayTile ("OverlayTile", Vector) = (0.25,0.25,1,1)
_OverlayTex ("OverlayTex", 2D) = "white" {}
_OverlayBrightness ("OverlayBrightness", Float) = 2
_OverlayAdd ("OverlayAdd", Float) = 0
_Specular ("Specular", 2D) = "white" {}
_SpecPower ("SpecPower", Float) = 1
_Glossiness ("Glossiness", Float) = 0.4
_Bumpmap ("Bumpmap", 2D) = "white" {}
	}
	Category {
		SubShader { 
//#Blend
ZWrite On
//#CatTags
Tags { "RenderType"="Opaque" }
Lighting On
Cull Back
//#LOD
LOD 600
//#GrabPass
		CGPROGRAM
//#LightingModelTag
#pragma surface surf ShaderFusion vertex:vert alphatest:_Cutoff addshadow fullforwardshadows novertexlights
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
float _MainBrightness_Add;
float4 _UV_Tiling;
sampler2D _MainTex;
float4 _OverlayTile;
sampler2D _OverlayTex;
float _OverlayBrightness;
float _OverlayAdd;
sampler2D _Specular;
float _SpecPower;
float _Glossiness;
sampler2D _Bumpmap;
float4 _Color;
		struct Input {
//#UVDefs
float4 sfuv1;
float3 worldPos;
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
float4 node5 = tex2D(_MainTex,((_UV_Tiling) * (IN.sfuv1.xy)));
float3 node21 = float3(((IN.worldPos).x),((IN.worldPos).z),((IN.worldPos).y));
float4 node13 = tex2D(_OverlayTex,((node21) * (_OverlayTile)));
float4 node8 = tex2D(_Specular,IN.sfuv1.xy);
float4 node6 = tex2D(_Bumpmap,((_UV_Tiling) * (IN.sfuv1.xy)));
//#FragBody
normal = (float4(float3(UnpackNormal((node6))),0));
gloss = (_Glossiness);
specular = ((node8) * (_SpecPower));
diffuse = ((_MainBrightness_Add) + ((node5) * (((node13) * (_OverlayBrightness)) + (_OverlayAdd))));
			
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
