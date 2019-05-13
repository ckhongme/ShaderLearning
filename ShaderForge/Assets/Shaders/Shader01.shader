// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:3138,x:32877,y:32704,varname:node_3138,prsc:2|emission-4731-OUT;n:type:ShaderForge.SFN_Color,id:7241,x:32445,y:32731,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_7241,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.3033088,c2:0.527982,c3:0.8088235,c4:1;n:type:ShaderForge.SFN_Tex2d,id:2287,x:32558,y:32946,ptovrint:False,ptlb:node_2287,ptin:_node_2287,varname:node_2287,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:e0a571b2f1a21d446a1afcab341ccf2c,ntxv:0,isnm:False|UVIN-3086-UVOUT;n:type:ShaderForge.SFN_Multiply,id:4731,x:32719,y:32835,varname:node_4731,prsc:2|A-7241-RGB,B-2287-R;n:type:ShaderForge.SFN_Panner,id:3086,x:32389,y:32946,varname:node_3086,prsc:2,spu:1,spv:1|UVIN-2469-UVOUT,DIST-2822-OUT;n:type:ShaderForge.SFN_TexCoord,id:2469,x:32221,y:32872,varname:node_2469,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Slider,id:2822,x:32039,y:33061,ptovrint:False,ptlb:node_2822,ptin:_node_2822,varname:node_2822,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;proporder:7241-2287-2822;pass:END;sub:END;*/

Shader "Shader Forge/Shader01" {
    Properties {
        _Color ("Color", Color) = (0.3033088,0.527982,0.8088235,1)
        _node_2287 ("node_2287", 2D) = "white" {}
        _node_2822 ("node_2822", Range(0, 1)) = 0
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _Color;
            uniform sampler2D _node_2287; uniform float4 _node_2287_ST;
            uniform float _node_2822;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
////// Emissive:
                float2 node_3086 = (i.uv0+_node_2822*float2(1,1));
                float4 _node_2287_var = tex2D(_node_2287,TRANSFORM_TEX(node_3086, _node_2287));
                float3 emissive = (_Color.rgb*_node_2287_var.r);
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
