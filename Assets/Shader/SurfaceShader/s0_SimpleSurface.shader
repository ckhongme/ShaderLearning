Shader "CK/Surface/SimpleSurface"
{  
   Subshader
   {
       Tags { "RenderType" = "Opaque" }
       
	   CGPROGRAM
       
	   #pragma surface surf Lambert
       struct Input
	   {
           float4 color : COLOR;
           float3 worldPos;
       };
       
	   void surf (Input IN, inout SurfaceOutput o)
	   {
           o.Albedo = float3(0.5,0.2,0.3);
       }
       ENDCG
   }
   FallBack "Diffuse"
}