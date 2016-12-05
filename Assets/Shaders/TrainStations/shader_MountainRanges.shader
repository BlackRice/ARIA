//#EditorFriendly
//#node12:posx=-768:posy=-15:title=ParamVector:title2=UV1Tile:input0=(1,1,1,1):input0type=Vector4:
//#node11:posx=-631:posy=-71:title=Multiply:input0=1:input0type=float:input0linkindexnode=10:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=12:input1linkindexoutput=0:
//#node10:posx=-774:posy=-92:title=UV1:
//#node9:posx=-172:posy=186:title=ParamFloat:title2=gloss:input0=1:input0type=float:
//#node8:posx=-515:posy=-59:title=ParamFloat:title2=brightness:input0=1:input0type=float:
//#node7:posx=-379:posy=-92:title=Multiply:input0=1:input0type=float:input0linkindexnode=5:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=8:input1linkindexoutput=0:
//#node6:posx=-503:posy=109:title=Texture:title2=alpha:input0=(0,0):input0type=Vector2:input0linkindexnode=11:input0linkindexoutput=0:
//#node5:posx=-518:posy=-145:title=Texture:title2=Main:input0=(0,0):input0type=Vector2:input0linkindexnode=11:input0linkindexoutput=0:
//#node4:posx=0:posy=0:title=Lighting:title2=On:
//#node3:posx=0:posy=0:title=DoubleSided:title2=Back:
//#node2:posx=0:posy=0:title=FallbackInfo:title2=Transparent/Cutout/VertexLit:input0=1:input0type=float:
//#node1:posx=0:posy=0:title=LODInfo:title2=LODInfo1:input0=600:input0type=float:
//#masterNode:posx=0:posy=0:title=Master Node:input1linkindexnode=7:input1linkindexoutput=0:input3linkindexnode=9:input3linkindexoutput=0:input4linkindexnode=6:input4linkindexoutput=0:
//#sm=3.0
//#blending=Normal
//#ShaderName
Shader "ShaderFusion/shader_MountainRanges" {
	Properties {
_Color ("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
_SpecColor ("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
//#ShaderProperties
_UV1Tile ("UV1Tile", Vector) = (1,1,1,1)
_Main ("Main", 2D) = "white" {}
_brightness ("brightness", Float) = 1
_gloss ("gloss", Float) = 1
_alpha ("alpha", 2D) = "white" {}
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
float4 _UV1Tile;
sampler2D _Main;
float _brightness;
float _gloss;
sampler2D _alpha;
float4 _Color;
		struct Input {
//#UVDefs
float4 sfuv1;
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
float4 node5 = tex2D(_Main,((IN.sfuv1.xy) * (_UV1Tile)));
float4 node6 = tex2D(_alpha,((IN.sfuv1.xy) * (_UV1Tile)));
//#FragBody
alpha = (node6);
gloss = (_gloss);
emissive = ((node5) * (_brightness));
			
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
