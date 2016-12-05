//#EditorFriendly
//#node25:posx=-840.5:posy=-117.5:title=TexWithXform:title2=Dif2:input0=(0,0):input0type=Vector2:input0linkindexnode=10:input0linkindexoutput=0:
//#node24:posx=-879.5:posy=-206.5:title=ParamFloat:title2=UV1Tile:input0=1:input0type=float:
//#node23:posx=-782.5:posy=-271.5:title=Multiply:input0=1:input0type=float:input0linkindexnode=7:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=24:input1linkindexoutput=0:
//#node22:posx=-1382:posy=-241:title=ParamVector:title2=L2_UV_Proportion:input0=(1,1,1,1):input0type=Vector4:
//#node21:posx=-1249:posy=-206:title=Multiply:input0=1:input0type=float:input0linkindexnode=22:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=7:input1linkindexoutput=0:
//#node20:posx=-682:posy=-202:title=TexWithXform:title2=Main:input0=(0,0):input0type=Vector2:input0linkindexnode=23:input0linkindexoutput=0:
//#node19:posx=-631:posy=-102:title=Clamp:input0=(1,1,1,1):input0type=Vector4:input0linkindexnode=17:input0linkindexoutput=0:
//#node18:posx=-863:posy=-48:title=ParamFloat:title2=Dif2_Brightness:input0=0:input0type=float:
//#node17:posx=-735:posy=-111:title=Add:input0=0:input0type=float:input0linkindexnode=25:input0linkindexoutput=0:input1=0:input1type=float:input1linkindexnode=18:input1linkindexoutput=0:
//#node16:posx=-515:posy=-111:title=Multiply:input0=1:input0type=float:input0linkindexnode=20:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=19:input1linkindexoutput=0:
//#node15:posx=-410:posy=181:title=Texture:title2=Normal:input0=(0,0):input0type=Vector2:input0linkindexnode=23:input0linkindexoutput=0:
//#node14:posx=-411:posy=96:title=ParamFloat:title2=Gloss:input0=1:input0type=float:
//#node13:posx=-421:posy=20:title=ParamFloat:title2=Spec:input0=1:input0type=float:
//#node12:posx=-1480:posy=-56:title=ParamFloat:title2=L2_UV_Tile:input0=1:input0type=float:
//#node11:posx=-1122:posy=-1:title=ParamVector:title2=L2_UV_Offset:input0=(0,0,0,0):input0type=Vector4:
//#node10:posx=-945:posy=-120:title=Add:input0=0:input0type=float:input0linkindexnode=8:input0linkindexoutput=0:input1=0:input1type=float:input1linkindexnode=11:input1linkindexoutput=0:
//#node9:posx=-1368:posy=-59:title=Divide:input0=1:input0type=float:input1=1:input1type=float:input1linkindexnode=12:input1linkindexoutput=0:
//#node8:posx=-1083:posy=-128:title=Multiply:input0=1:input0type=float:input0linkindexnode=21:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=9:input1linkindexoutput=0:
//#node7:posx=-1383:posy=-149:title=UV1:
//#node6:posx=-266:posy=2:title=Multiply:input0=1:input0type=float:input0linkindexnode=16:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=13:input1linkindexoutput=0:
//#node5:posx=-304:posy=185:title=UnpackNormal:input0=0:input0type=float:input0linkindexnode=15:input0linkindexoutput=0:
//#node4:posx=0:posy=0:title=Lighting:title2=On:
//#node3:posx=0:posy=0:title=DoubleSided:title2=Back:
//#node2:posx=0:posy=0:title=FallbackInfo:title2=Transparent/Cutout/VertexLit:input0=1:input0type=float:
//#node1:posx=0:posy=0:title=LODInfo:title2=LODInfo1:input0=600:input0type=float:
//#masterNode:posx=0:posy=0:title=Master Node:input0linkindexnode=16:input0linkindexoutput=0:input2linkindexnode=6:input2linkindexoutput=0:input3linkindexnode=14:input3linkindexoutput=0:input5linkindexnode=5:input5linkindexoutput=0:
//#sm=3.0
//#blending=Normal
//#ShaderName
Shader "ShaderFusion/Shader_DualTextures_Simplified_02" {
	Properties {
_Color ("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
_SpecColor ("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
//#ShaderProperties
_UV1Tile ("UV1Tile", Float) = 1
_Main ("Main", 2D) = "white" {}
_L2_UV_Proportion ("L2_UV_Proportion", Vector) = (1,1,1,1)
_L2_UV_Tile ("L2_UV_Tile", Float) = 1
_L2_UV_Offset ("L2_UV_Offset", Vector) = (0,0,0,0)
_Dif2 ("Dif2", 2D) = "white" {}
_Dif2_Brightness ("Dif2_Brightness", Float) = 0
_Spec ("Spec", Float) = 1
_Gloss ("Gloss", Float) = 1
_Normal ("Normal", 2D) = "white" {}
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
float _UV1Tile;
sampler2D _Main;
float4 _L2_UV_Proportion;
float _L2_UV_Tile;
float4 _L2_UV_Offset;
sampler2D _Dif2;
float _Dif2_Brightness;
float _Spec;
float _Gloss;
sampler2D _Normal;
float4 _Color;
		struct Input {
//#UVDefs
float4 sfuv1;
float2 uv_Main;
float2 uv_Dif2;
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
float4 node20 = tex2D(_Main,((IN.sfuv1.xy) * (_UV1Tile)));
float4 node25 = tex2D(_Dif2,((((_L2_UV_Proportion) * (IN.sfuv1.xy)) * (1 / (_L2_UV_Tile))) + (_L2_UV_Offset)));
float4 node15 = tex2D(_Normal,((IN.sfuv1.xy) * (_UV1Tile)));
//#FragBody
normal = (float4(float3(UnpackNormal((node15))),0));
gloss = (_Gloss);
specular = (((node20) * (saturate(((node25) + (_Dif2_Brightness))))) * (_Spec));
diffuse = ((node20) * (saturate(((node25) + (_Dif2_Brightness)))));
			
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
