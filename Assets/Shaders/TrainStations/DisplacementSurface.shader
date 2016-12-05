//#EditorFriendly
//#node21:posx=-645:posy=146:title=ParamFloat:title2=DisplaceCenter:input0=0.5:input0type=float:
//#node20:posx=-421:posy=180:title=Add:input0=0:input0type=float:input0linkindexnode=19:input0linkindexoutput=0:input1=0:input1type=float:input1linkindexnode=18:input1linkindexoutput=0:
//#node19:posx=-528:posy=100:title=UV1:
//#node18:posx=-539:posy=202:title=DisplaceOffset:input0=0.5:input0type=float:input0linkindexnode=21:input0linkindexoutput=0:input1=0.1:input1type=float:input1linkindexnode=15:input1linkindexoutput=0:
//#node17:posx=-744:posy=215:title=Vector.X:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=14:input0linkindexoutput=0:
//#node16:posx=-750:posy=277:title=ParamFloat:title2=DisplacementHeight:input0=0.01:input0type=float:
//#node15:posx=-640:posy=217:title=Multiply:input0=1:input0type=float:input0linkindexnode=17:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=16:input1linkindexoutput=0:
//#node14:posx=-746:posy=161:title=Texture:title2=Displacement:input0=(0,0):input0type=Vector2:
//#node13:posx=-169:posy=72:title=Multiply:input0=1:input0type=float:input0linkindexnode=12:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=8:input1linkindexoutput=0:
//#node12:posx=-284:posy=44:title=Vector.W:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=11:input0linkindexoutput=0:
//#node11:posx=-402:posy=-87:title=Texture:title2=Spec:input0=(0,0):input0type=Vector2:input0linkindexnode=20:input0linkindexoutput=0:
//#node10:posx=-268:posy=181:title=TexWithXform:title2=BumpMap:input0=(0,0):input0type=Vector2:input0linkindexnode=20:input0linkindexoutput=0:
//#node9:posx=-139:posy=174:title=UnpackNormal:input0=0:input0type=float:input0linkindexnode=10:input0linkindexoutput=0:
//#node8:posx=-283:posy=115:title=ParamFloat:title2=Glossiness:input0=1:input0type=float:
//#node7:posx=-412:posy=-5:title=ParamFloat:title2=SpecularPower:input0=1:input0type=float:
//#node6:posx=-248:posy=-44:title=Multiply:input0=1:input0type=float:input0linkindexnode=11:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=7:input1linkindexoutput=0:
//#node5:posx=-343:posy=-164:title=TexWithXform:title2=MainTex:input0=(0,0):input0type=Vector2:input0linkindexnode=20:input0linkindexoutput=0:
//#node4:posx=0:posy=0:title=Lighting:title2=On:
//#node3:posx=0:posy=0:title=DoubleSided:title2=Off:
//#node2:posx=0:posy=0:title=FallbackInfo:title2=Transparent/Cutout/VertexLit:input0=1:input0type=float:
//#node1:posx=0:posy=0:title=LODInfo:title2=LODInfo1:input0=600:input0type=float:
//#masterNode:posx=0:posy=0:title=Master Node:input0linkindexnode=5:input0linkindexoutput=0:input2linkindexnode=6:input2linkindexoutput=0:input3linkindexnode=13:input3linkindexoutput=0:input5linkindexnode=9:input5linkindexoutput=0:
//#sm=3.0
//#blending=Normal
//#ShaderName
Shader "ShaderFusion/DisplacementSurface" {
	Properties {
_Color ("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
_SpecColor ("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
//#ShaderProperties
_DisplaceCenter ("DisplaceCenter", Float) = 0.5
_Displacement ("Displacement", 2D) = "white" {}
_DisplacementHeight ("DisplacementHeight", Float) = 0.01
_MainTex ("MainTex", 2D) = "white" {}
_Spec ("Spec", 2D) = "white" {}
_SpecularPower ("SpecularPower", Float) = 1
_Glossiness ("Glossiness", Float) = 1
_BumpMap ("BumpMap", 2D) = "white" {}
	}
	Category {
		SubShader { 
//#Blend
ZWrite On
//#CatTags
Tags { "RenderType"="Opaque" }
Lighting On
Cull Off
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
float _DisplaceCenter;
sampler2D _Displacement;
float _DisplacementHeight;
sampler2D _MainTex;
sampler2D _Spec;
float _SpecularPower;
float _Glossiness;
sampler2D _BumpMap;
float4 _Color;
		struct Input {
//#UVDefs
float4 sfuv1;
float3 viewDir;
float2 uv_MainTex;
float2 uv_BumpMap;
		INTERNAL_DATA
		};
		
		void vert (inout appdata_full v, out Input o) {
//#DeferredVertexBody
UNITY_INITIALIZE_OUTPUT(Input, o);
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
float4 node14 = tex2D(_Displacement,IN.sfuv1.xy);
float4 node5 = tex2D(_MainTex,((IN.sfuv1.xy) + (ParallaxOffset((_DisplaceCenter), (((node14).x) * (_DisplacementHeight)), IN.viewDir))));
float4 node11 = tex2D(_Spec,((IN.sfuv1.xy) + (ParallaxOffset((_DisplaceCenter), (((node14).x) * (_DisplacementHeight)), IN.viewDir))));
float4 node10 = tex2D(_BumpMap,((IN.sfuv1.xy) + (ParallaxOffset((_DisplaceCenter), (((node14).x) * (_DisplacementHeight)), IN.viewDir))));
//#FragBody
normal = (float4(float3(UnpackNormal((node10))),0));
gloss = (((node11).w) * (_Glossiness));
specular = ((node11) * (_SpecularPower));
diffuse = (node5);
			
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
