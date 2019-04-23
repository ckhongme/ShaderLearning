Shader "CK/Surface/Surface_Alpha"
{
	Properties
	{
		_MainTex ("MainTex", 2D) = "white" {}
		
		_ScaleX("ScaleX", float) = 1.0		//纹理_MainTex的缩放量X
		_ScaleY("ScaleY", float) = 1.0		//纹理_MainTex的缩放量Y
		_TranslateX("TranslateX", float) = 0.0		//纹理_MainTex的平移量X
		_TranslateY("TranslateY", float) = 0.0		//纹理_MainTex的平移量Y
		_Angle("Angle", float) = 0.0		//纹理_MainTex的旋转角度

		_Color("Color", Color) = (0,0,0,0)
		_Alpha("Alpha", Range(0, 1)) = 0.5
		
		_NormalTex("Normal", 2D) = "white"{}
	}

	SubShader
	{
		Tags { "RenderType"="Transparent" }
		LOD 200

		CGPROGRAM
		
		//如果需要模型透明，必须加可选参数 alpha
		#pragma surface surf Lambert alpha

		sampler2D _MainTex;
		float _ScaleX, _ScaleY, _TranslateX, _TranslateY, _Angle;	
		float4 _Color;
		float _Alpha;
		sampler2D _NormalTex;

	   	struct Input
	   	{
			float4 color : COLOR;		//顶点的颜色
			float3 worldPos;			//顶点的世界坐标
			float2 uv_MainTex;			//名字为 _MainTex 的纹理的 uv坐标
	   	};

	   	void surf(Input IN, inout SurfaceOutput o)
	   	{
			float2 uv = IN.uv_MainTex;
		
			uv = float2(uv.x * _ScaleX + _TranslateX, uv.y * _ScaleY + _TranslateY);		//缩放偏移uv
			uv -= float2(0.5, 0.5);		//以纹理中心为旋转中心
			uv = float2((cos(_Angle)*uv.x - sin(_Angle)*uv.y), (sin(_Angle)*uv.x + cos(_Angle)*uv.y));
			uv += float2(0.5, 0.5);		//恢复纹理位置

			//_MainTex 纹理采样
			fixed4 color = tex2D(_MainTex, uv);		

			o.Albedo = color.rgb;

			//根据世界坐标进行透明度设置
			if (IN.worldPos.y > 0)
				o.Alpha = _Alpha;
			else
				o.Alpha = color.a;
	   	}

	   	ENDCG
	}

	FallBack "Diffuse"
}
