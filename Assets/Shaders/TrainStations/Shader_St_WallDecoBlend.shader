//#EditorFriendly
//#node25:posx=-464:posy=337:title=Multiply:input0=1:input0type=float:input0linkindexnode=17:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=23:input1linkindexoutput=0:
//#node24:posx=-470:posy=251:title=Multiply:input0=1:input0type=float:input0linkindexnode=16:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=22:input1linkindexoutput=0:
//#node23:posx=-564:posy=423:title=Vector.Y:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=21:input0linkindexoutput=0:
//#node22:posx=-603:posy=295:title=Vector.X:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=21:input0linkindexoutput=0:
//#node21:posx=-745:posy=453:title=ParamVector:title2=NormalStrength:input0=(0,0,0,0):input0type=Vector4:
//#node20:posx=-422:posy=557:title=Vector.W:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=7:input0linkindexoutput=0:
//#node19:posx=-279:posy=283:title=Assembler:input0=1:input0type=float:input0linkindexnode=24:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=25:input1linkindexoutput=0:input2=1:input2type=float:input2linkindexnode=18:input2linkindexoutput=0:input3=1:input3type=float:input3linkindexnode=20:input3linkindexoutput=0:
//#node18:posx=-421:posy=476:title=Vector.Z:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=7:input0linkindexoutput=0:
//#node17:posx=-592:posy=357:title=Vector.Y:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=7:input0linkindexoutput=0:
//#node16:posx=-611:posy=214:title=Vector.X:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=7:input0linkindexoutput=0:
//#node15:posx=-918:posy=383:title=TexWithXform:title2=Normal:input0=(0,0):input0type=Vector2:
//#node14:posx=-583:posy=111:title=Multiply:input0=1:input0type=float:input0linkindexnode=6:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=13:input1linkindexoutput=0:
//#node13:posx=-826:posy=288:title=ParamFloat:title2=DecoBrightness:input0=1:input0type=float:
//#node12:posx=-806:posy=194:title=Texture:title2=alpha:input0=(0,0):input0type=Vector2:
//#node11:posx=-200:posy=30:title=Multiply:input0=1:input0type=float:input0linkindexnode=10:input0linkindexoutput=0:input1=1:input1type=float:input1linkindexnode=8:input1linkindexoutput=0:
//#node10:posx=-435:posy=-36:title=Lerp:input0=(0,0,0,0):input0type=Vector4:input0linkindexnode=5:input0linkindexoutput=0:input1=(0,0,0,0):input1type=Vector4:input1linkindexnode=14:input1linkindexoutput=0:input2=0:input2type=float:input2linkindexnode=12:input2linkindexoutput=0:
//#node9:posx=-349:posy=169:title=ParamFloat:title2=Gloss:input0=1:input0type=float:
//#node8:posx=-357:posy=98:title=ParamFloat:title2=Spec:input0=1:input0type=float:
//#node7:posx=-781:posy=376:title=UnpackNormal:input0=0:input0type=float:input0linkindexnode=15:input0linkindexoutput=0:
//#node6:posx=-763:posy=33:title=TexWithXform:title2=Main:input0=(0,0):input0type=Vector2:
//#node5:posx=-760:posy=115:title=TexWithXform:title2=Main2:input0=(0,0):input0type=Vector2:
//#node4:posx=0:posy=0:title=Lighting:title2=On:
//#node3:posx=0:posy=0:title=DoubleSided:title2=Back:
//#node2:posx=0:posy=0:title=FallbackInfo:title2=Transparent/Cutout/VertexLit:input0=1:input0type=float:
//#node1:posx=0:posy=0:title=LODInfo:title2=LODInfo1:input0=600:input0type=float:
//#masterNode:posx=0:posy=0:title=Master Node:input0linkindexnode=10:input0linkindexoutput=0:input2linkindexnode=11:input2linkindexoutput=0:input3linkindexnode=9:input3linkindexoutput=0:input5linkindexnode=19:input5linkindexoutput=0:
//#sm=3.0
//#blending=Normal
//#ShaderName
Shader "ShaderFusion/Shader_St_WallDecoBlend" {
	Properties {
_Color ("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
_SpecColor ("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
//#ShaderProperties
_Main2 ("Main2", 2D) = "white" {}
_Main ("Main", 2D) = "white" {}
_DecoBrightness ("DecoBrightness", Float) = 1
_alpha ("alpha", 2D) = "white" {}
_Spec ("Spec", Float) = 1
_Gloss ("Gloss", Float) = 1
_Normal ("Normal", 2D) = "white" {}
_NormalStrength ("NormalStrength", Vector) = (0,0,0,0)
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
sampler2D _Main2;
sampler2D _Main;
float _DecoBrightness;
sampler2D _alpha;
float _Spec;
float _Gloss;
sampler2D _Normal;
float4 _NormalStrength;
float4 _Color;
		struct Input {
//#UVDefs
float2 uv_Main2;
float2 uv_Main;
float4 sfuv1;
float2 uv_Normal;
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
float4 node5 = tex2D(_Main2,IN.uv_Main2.xy);
float4 node6 = tex2D(_Main,IN.uv_Main.xy);
float4 node12 = tex2D(_alpha,IN.sfuv1.xy);
float4 node15 = tex2D(_Normal,IN.uv_Normal.xy);
float4 node19 = float4((((float4(float3(UnpackNormal((node15))),0)).x) * ((_NormalStrength).x)),(((float4(float3(UnpackNormal((node15))),0)).y) * ((_NormalStrength).y)),((float4(float3(UnpackNormal((node15))),0)).z),((float4(float3(UnpackNormal((node15))),0)).w));
//#FragBody
normal = (node19);
gloss = (_Gloss);
specular = ((lerp((node5),((node6) * (_DecoBrightness)),(node12))) * (_Spec));
diffuse = (lerp((node5),((node6) * (_DecoBrightness)),(node12)));
			
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
