﻿Shader "CK/SimpleSurface"
{  
   Subshader
   {
       Tags { "RenderType" = "Opaque" }
       
	   CGPROGRAM
       
	   #pragma surface surf Lambert
       struct Input
	   {
           float4 clolr : COLOR;
       };
       
	   void surf (Input IN, inout SurfaceOutput o)
	   {
           o.Albedo = 1;
       }
       ENDCG
   }
   FallBack "Diffuse"
}