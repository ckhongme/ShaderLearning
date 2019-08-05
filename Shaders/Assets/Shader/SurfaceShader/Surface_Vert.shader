Shader "CK/Surface/Surface_Vert"
{
	Properties
	{
		_Color("Color", Color) = (0,0,0,0)
		_MainTex("Base(RGB)", 2D) = "white"{}
		_NormalTex("Normal", 2D) = "white"{}

		_Snow("Snow Level", float) = 0
		_SnowColor("Snow Color", Color) = (0,0,0,0)
		_SnowDir("Snow Direction", Vector) = (0,1,0)		//默认雪是垂直落下的

		_SnowDepth("Snow Depth", Range(0, 0.3)) = 0.1
		
		_RimColor("RimColor", Color) = (0.0, 0.57, 0.55, 0.0)
		_RimPower("RimPower", Range(0, 8.0)) = 0.5
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM

		#pragma surface surf CustomDiffuse vertex:vert

		//光照函数 漫反射 
		float4 LightingCustomDiffuse(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			float4 difLight = max(0, dot(s.Normal, lightDir));
			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb * difLight * atten * 2;
			col.a = s.Alpha;
			return col;
		}

		float4 _Color;
		sampler2D _MainTex;
		sampler2D _NormalTex;

		float _Snow;
		float4 _SnowColor;
		float4 _SnowDir;
		float _SnowDepth;

		float4 _RimColor;
		float  _RimPower;

		struct Input
		{
			float2 uv_MainTex;
			float2 uv_NormalTex;
			float3 viewDir;
			float3 worldPos;
			float3 worldNormal; INTERNAL_DATA		//输入点的世界法线方向
		};

		//改变顶点坐标
		void vert(inout appdata_full v)
		{
			float4 sn = mul(transpose(unity_ObjectToWorld), _SnowDir);

			if (dot(v.normal, sn.xyz) >= lerp(1, -1, (_Snow * 2) / 3))
			{
				v.vertex.xyz += (sn.xyz + v.normal) * _SnowDepth * _Snow;
			}
		}

		void surf(Input IN, inout SurfaceOutput o)
		{
			float4 c = tex2D(_MainTex, IN.uv_MainTex);
			//_NormalTex 纹理采样
			float4 normalTex = tex2D(_NormalTex, IN.uv_NormalTex);
			//根据NormalTex的信息，对o.Normal进行修改
			o.Normal = UnpackNormal(normalTex);

			//法线方向与世界坐标空间的Y轴正方向保持一致积雪多，否则积雪就少雪 
			if (dot(WorldNormalVector(IN, o.Normal), _SnowDir.xyz) > lerp(1, -1, _Snow))
			{
				o.Albedo = _SnowColor.rgb;  //替换该点的颜色
			}
			else
			{
				o.Albedo = c.rgb;
			}
			o.Alpha = c.a;

			//saturate 限制值于[0,1]之间
			half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));

			float3 rimColor = _RimColor.rgb;
			if (IN.worldPos.y < 0)
				o.Emission = rimColor * pow(rim, _RimPower);
		}

		ENDCG
	}

	Fallback "Diffuse"
}