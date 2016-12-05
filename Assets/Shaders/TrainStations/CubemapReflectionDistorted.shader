// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

//#EditorFriendly
//#node26:posx=-476.5:posy=-438:title=Vector.W:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=15:input0linkindexoutput=0:
//#node25:posx=-843.5:posy=-105:title=Lerp:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=24:input0linkindexoutput=0:input1=(0,0,0,0):input1type=Vector4:input1linkindexnode=7:input1linkindexoutput=0:input2=0.5:input2type=float:input2linkindexnode=26:input2linkindexoutput=0:
//#node24:posx=-1017.5:posy=-142:title=WorldNormal:
//#node23:posx=-712:posy=28:title=ParamFloat:title2=CubemapAlphaAdd:input0=1:input0type=float:
//#node22:posx=-596:posy=-8:title=Multiply:input0=1:input0type=float:input0linkindexnode=18:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=23:input1linkindexoutput=0:
//#node21:posx=-357:posy=110:title=ParamFloat:title2=ReflectContrast:input0=1:input0type=float:
//#node20:posx=-249:posy=-1:title=Power:input0=0:input0type=float:input0linkindexnode=13:input0linkindexoutput=0:input1=0:input1type=float:input1linkindexnode=21:input1linkindexoutput=0:
//#node19:posx=-401:posy=-6:title=Multiply:input0=1:input0type=float:input0linkindexnode=6:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=17:input1linkindexoutput=0:
//#node18:posx=-604:posy=-77:title=Vector.W:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=6:input0linkindexoutput=0:
//#node17:posx=-502:posy=19:title=Add:input0=0:input0type=float:input0linkindexnode=22:input0linkindexoutput=0:input1=1:input1type=float:
//#node16:posx=-1018:posy=-19:title=Texture:title2=BumpMap:input0=(0,0):input0type=Vector2:
//#node15:posx=-190:posy=-226:title=Texture:title2=MainTex:input0=(0,0):input0type=Vector2:
//#node14:posx=-374:posy=-166:title=Texture:title2=Spec:input0=(0,0):input0type=Vector2:
//#node13:posx=-307:posy=-81:title=Multiply:input0=1:input0type=float:input0linkindexnode=14:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=19:input1linkindexoutput=0:
//#node12:posx=-133:posy=9:title=Multiply:input0=1:input0type=float:input0linkindexnode=20:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=11:input1linkindexoutput=0:
//#node11:posx=-224:posy=110:title=ParamFloat:title2=ReflectionPower:input0=1:input0type=float:
//#node10:posx=-98:posy=125:title=ParamFloat:title2=Glossiness:input0=1:input0type=float:
//#node9:posx=-373:posy=-227:title=ParamFloat:title2=SpecPower:input0=1:input0type=float:
//#node8:posx=-190:posy=-151:title=Multiply:input0=0:input0type=float:input0linkindexnode=9:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=14:input1linkindexoutput=0:
//#node7:posx=-973:posy=69:title=UnpackNormal:input0=0:input0type=float:input0linkindexnode=16:input0linkindexoutput=0:
//#node6:posx=-604:posy=-138:title=CubeMap:title2=CubeMap1:input0=(0,0):input0type=Vector2:input0linkindexnode=5:input0linkindexoutput=0:
//#node5:posx=-737:posy=-49:title=Reflection:input0=0:input0type=float:input1=0:input1type=float:input1linkindexnode=25:input1linkindexoutput=0:
//#node4:posx=0:posy=0:title=Lighting:title2=On:
//#node3:posx=0:posy=0:title=DoubleSided:title2=Back:
//#node2:posx=0:posy=0:title=FallbackInfo:title2=Transparent/Cutout/VertexLit:input0=1:input0type=float:
//#node1:posx=0:posy=0:title=LODInfo:title2=LODInfo1:input0=600:input0type=float:
//#masterNode:posx=0:posy=0:title=Master Node:input0linkindexnode=15:input0linkindexoutput=0:input1linkindexnode=12:input1linkindexoutput=0:input2linkindexnode=8:input2linkindexoutput=0:input3linkindexnode=10:input3linkindexoutput=0:input5linkindexnode=7:input5linkindexoutput=0:
//#sm=3.0
//#blending=Normal
//#ShaderName
Shader "ShaderFusion/CubemapReflectionDistorted" {
	Properties {
_Color ("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
_SpecColor ("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
//#ShaderProperties
_MainTex ("MainTex", 2D) = "white" {}
_Spec ("Spec", 2D) = "white" {}
_BumpMap ("BumpMap", 2D) = "white" {}
_CubeMap1 ("CubeMap1", Cube) = "_Skybox" { TexGen CubeReflect }
_CubemapAlphaAdd ("CubemapAlphaAdd", Float) = 1
_ReflectContrast ("ReflectContrast", Float) = 1
_ReflectionPower ("ReflectionPower", Float) = 1
_SpecPower ("SpecPower", Float) = 1
_Glossiness ("Glossiness", Float) = 1
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
sampler2D _MainTex;
sampler2D _Spec;
sampler2D _BumpMap;
samplerCUBE _CubeMap1;
float _CubemapAlphaAdd;
float _ReflectContrast;
float _ReflectionPower;
float _SpecPower;
float _Glossiness;
float4 _Color;
		struct Input {
//#UVDefs
float4 sfuv1;
float3 worldNormal;
float3 worldRefl;
		INTERNAL_DATA
		};
		
		void vert (inout appdata_full v, out Input o) {
//#DeferredVertexBody
UNITY_INITIALIZE_OUTPUT(Input, o)
o.sfuv1.xy = v.texcoord.xy;
o.worldNormal = mul((float3x3)unity_ObjectToWorld,v.normal);
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
float4 node15 = tex2D(_MainTex,IN.sfuv1.xy);
float4 node14 = tex2D(_Spec,IN.sfuv1.xy);
float4 node16 = tex2D(_BumpMap,IN.sfuv1.xy);
float4 node6 = texCUBE(_CubeMap1,WorldReflectionVector(IN, ((lerp((IN.worldNormal),(float4(float3(UnpackNormal((node16))),0)),((node15).w))))));
//#FragBody
normal = (float4(float3(UnpackNormal((node16))),0));
gloss = (_Glossiness);
specular = ((_SpecPower) * (node14));
emissive = ((pow(((node14) * ((node6) * ((((node6).w) * (_CubemapAlphaAdd)) + 1))),(_ReflectContrast))) * (_ReflectionPower));
diffuse = (node15);
			
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
