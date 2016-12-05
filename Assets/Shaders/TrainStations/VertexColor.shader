//#EditorFriendly
//#node22:posx=-224:posy=-389.5:title=Texture:title2=Texture1:input0=(0,0):input0type=Vector2:
//#node21:posx=-399:posy=-245.5:title=ParamFloat:title2=All_or_XYZW:input0=0:input0type=float:
//#node20:posx=-312:posy=120.5:title=ParamFloat:title2=Y_or_ZW:input0=0:input0type=float:
//#node19:posx=-397:posy=-41.5:title=ParamFloat:title2=X_or_YZW:input0=0:input0type=float:
//#node18:posx=-304:posy=255.5:title=ParamFloat:title2=Z_or_W:input0=0:input0type=float:
//#node17:posx=-629:posy=329.5:title=Assembler:input0=1:input0type=float:input0linkindexnode=13:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=13:input1linkindexoutput=0:input2=1:input2type=float:input2linkindexnode=13:input2linkindexoutput=0:input3=1:input3type=float:input3linkindexnode=13:input3linkindexoutput=0:
//#node16:posx=-417:posy=186.5:title=Assembler:input0=1:input0type=float:input0linkindexnode=12:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=12:input1linkindexoutput=0:input2=1:input2type=float:input2linkindexnode=12:input2linkindexoutput=0:input3=1:input3type=float:input3linkindexnode=12:input3linkindexoutput=0:
//#node15:posx=-200:posy=198.5:title=Lerp:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=16:input0linkindexoutput=0:input1=(0,0,0,0):input1type=Vector4:input1linkindexnode=17:input1linkindexoutput=0:input2=0.5:input2type=float:input2linkindexnode=18:input2linkindexoutput=0:
//#node14:posx=-177:posy=91.5:title=Lerp:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=11:input0linkindexoutput=0:input1=(0,0,0,0):input1type=Vector4:input1linkindexnode=15:input1linkindexoutput=0:input2=0.5:input2type=float:input2linkindexnode=20:input2linkindexoutput=0:
//#node13:posx=-755:posy=334.5:title=Vector.W:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=5:input0linkindexoutput=0:
//#node12:posx=-559:posy=180.5:title=Vector.Z:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=5:input0linkindexoutput=0:
//#node11:posx=-503:posy=70.5:title=Assembler:input0=1:input0type=float:input0linkindexnode=10:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=10:input1linkindexoutput=0:input2=1:input2type=float:input2linkindexnode=10:input2linkindexoutput=0:input3=1:input3type=float:input3linkindexnode=10:input3linkindexoutput=0:
//#node10:posx=-640:posy=7.5:title=Vector.Y:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=5:input0linkindexoutput=0:
//#node9:posx=-250:posy=-61.5:title=Lerp:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=8:input0linkindexoutput=0:input1=(0,0,0,0):input1type=Vector4:input1linkindexnode=14:input1linkindexoutput=0:input2=0.5:input2type=float:input2linkindexnode=19:input2linkindexoutput=0:
//#node8:posx=-413:posy=-145.5:title=Assembler:input0=1:input0type=float:input0linkindexnode=7:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=7:input1linkindexoutput=0:input2=1:input2type=float:input2linkindexnode=7:input2linkindexoutput=0:input3=1:input3type=float:input3linkindexnode=7:input3linkindexoutput=0:
//#node7:posx=-559:posy=-204.5:title=Vector.X:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=5:input0linkindexoutput=0:
//#node6:posx=-262:posy=-291.5:title=Lerp:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=5:input0linkindexoutput=0:input1=(0,0,0,0):input1type=Vector4:input1linkindexnode=9:input1linkindexoutput=0:input2=0.5:input2type=float:input2linkindexnode=21:input2linkindexoutput=0:
//#node5:posx=-738:posy=-282:title=VertexColor:
//#node4:posx=0:posy=0:title=Lighting:title2=On:
//#node3:posx=0:posy=0:title=DoubleSided:title2=Back:
//#node2:posx=0:posy=0:title=FallbackInfo:title2=Transparent/Cutout/VertexLit:input0=1:input0type=float:
//#node1:posx=0:posy=0:title=LODInfo:title2=LODInfo1:input0=0:input0type=float:
//#masterNode:posx=0:posy=0:title=Master Node:input0linkindexnode=22:input0linkindexoutput=0:input1linkindexnode=6:input1linkindexoutput=0:
//#sm=3.0
//#blending=Normal
//#ShaderName
Shader "ShaderFusion/VertexColor" {
	Properties {
_Color ("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
_SpecColor ("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
//#ShaderProperties
_Texture1 ("Texture1", 2D) = "white" {}
_Z_or_W ("Z_or_W", Float) = 0
_Y_or_ZW ("Y_or_ZW", Float) = 0
_X_or_YZW ("X_or_YZW", Float) = 0
_All_or_XYZW ("All_or_XYZW", Float) = 0
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
LOD 0
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
sampler2D _Texture1;
float _Z_or_W;
float _Y_or_ZW;
float _X_or_YZW;
float _All_or_XYZW;
float4 _Color;
		struct Input {
//#UVDefs
float4 sfuv1;
float4 COLOR;
		INTERNAL_DATA
		};
		
		void vert (inout appdata_full v, out Input o) {
UNITY_INITIALIZE_OUTPUT(Input, o);
//#DeferredVertexBody
o.sfuv1.xy = v.texcoord.xy;
o.COLOR = v.color;
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
float4 node22 = tex2D(_Texture1,IN.sfuv1.xy);
float4 node8 = float4(((IN.COLOR).x),((IN.COLOR).x),((IN.COLOR).x),((IN.COLOR).x));
float4 node11 = float4(((IN.COLOR).y),((IN.COLOR).y),((IN.COLOR).y),((IN.COLOR).y));
float4 node16 = float4(((IN.COLOR).z),((IN.COLOR).z),((IN.COLOR).z),((IN.COLOR).z));
float4 node17 = float4(((IN.COLOR).w),((IN.COLOR).w),((IN.COLOR).w),((IN.COLOR).w));
//#FragBody
emissive = (lerp((IN.COLOR),(lerp((node8),(lerp((node11),(lerp((node16),(node17),(_Z_or_W))),(_Y_or_ZW))),(_X_or_YZW))),(_All_or_XYZW)));
diffuse = (node22);
			
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
