﻿// 基于位置的梯度着色器 (可实现几何体消失在雾/背景中的效果)
Shader "Custom/Fog"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Texture", 2D) = "white" {}
		_FogColor("Fog Color", Color) = (0.3, 0.4, 0.7, 1.0)
		_FogStart("Fog Start", float) = 0
		_FogEnd("Fog End", float) = 0
	}
	
	SubShader
	{
		Tags{ "RenderType" = "Opaque" }
		
CGPROGRAM
#pragma surface surf Lambert finalcolor:mycolor vertex:myvert

		struct Input
		{
			float2 uv_MainTex;
			half fog;
		};

		//声明两个颜色变量
		fixed4 _Color;		//几何体颜色
		fixed4 _FogColor;	//最终需要渐变成的背景颜色
		
		//声明2个新变量，用于对每个对象定义，渐变开始和渐变结束的y坐标。这样可以控制场景中每个物体的最终效果
		half _FogStart;
		half _FogEnd;
		
		sampler2D _MainTex;

		void myvert(inout appdata_full v, out Input data)
		{
			UNITY_INITIALIZE_OUTPUT(Input, data);
			
			//把顶点的输出坐标转换为游戏的世界坐标，以便计算特效的开始坐标和结束的y坐标
			float4 pos = mul(unity_ObjectToWorld, v.vertex).xyzw;
			
			//需要计算一下这个效果的而影响范围，它基于顶点的y坐标，然后用saturate函数将结果限制在0到1之间
			data.fog = saturate((_FogStart - pos.y) / (_FogStart - _FogEnd));
		}

		void mycolor(Input IN, SurfaceOutput o, inout fixed4 color)
		{
			fixed3 fogColor = _FogColor.rgb;
			fixed3 tintColor = _Color.rgb;

#ifdef UNITY_PASS_FORWARDADD
			fogColor = 0;
#endif
			//计算最终颜色，利用data.fog的强度，在_Color和_FogColor之间进行差值。color.rgb是由unity标准着色器计算的输出颜色，把它和_Color相乘。如果不这样做，会遗漏场景中的阴影和光照信息。
			color.rgb = lerp(color.rgb * tintColor, fogColor, IN.fog);

		}

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		}
		ENDCG
	
	}
	
	Fallback "Diffuse"
}

//需要创建一个新的材质，使用这个着色器，然后将它应用到所有的3d资源。使背景色和雾的颜色相同，同时还需要将相机的Background属性设置为雾的颜色。