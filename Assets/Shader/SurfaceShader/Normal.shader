Shader "CK/Normal"
{
	Properties
	{
		_Color("Color", Color) = (0,0,0,0)
		_MainTex("Base(RGB)", 2D) = "white"{}
		_NormalTex("Normal", 2D) = "white"{}
		//_NormalIntensity("Normal Map Intensity", Range(0,10)) = 1
	}

	SubShader
	{

	Tags { "RenderType" = "Opaque" }
	LOD 200

	CGPROGRAM

	//#pragma surface surf Lambert
	#pragma surface surf CustomDiffuse

	float4 _Color;
	sampler2D _MainTex;
	sampler2D _NormalTex;
	//float _NormalIntensity;

	struct Input
	{
		float2 uv_MainTex;
		float2 uv_NormalTex;
	};

	void surf(Input In, inout SurfaceOutput o)
	{
		float4 c = tex2D(_MainTex, In.uv_MainTex);
		o.Albedo = c.rgb;
		o.Alpha = c.a;

		float3 normalMap = UnpackNormal(tex2D(_NormalTex, In.uv_NormalTex));
		//normalMap = float3(normalMap.x * _NormalIntensity, normalMap.y * _NormalIntensity, normalMap.z);
		o.Normal = normalMap.rgb;
	}

	float4 LightingCustomDiffuse(SurfaceOutput s, fixed3 lightDir, fixed atten)
	{
		float4 difLight = max(0, dot(s.Normal, lightDir));
		float4 col;
		col.rgb = s.Albedo * _LightColor0.rgb * difLight * atten * 2; 
		col.a = s.Alpha;
		return col;
	}

	ENDCG

	}

	Fallback "Diffuse"
}