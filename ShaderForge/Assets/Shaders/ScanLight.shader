// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:9361,x:33383,y:32493,varname:node_9361,prsc:2|custl-8606-OUT,alpha-2424-A;n:type:ShaderForge.SFN_Tex2d,id:2424,x:32716,y:32506,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_2424,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:66321cc856b03e245ac41ed8a53e0ecc,ntxv:0,isnm:False;n:type:ShaderForge.SFN_TexCoord,id:5881,x:31375,y:32304,varname:node_5881,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Sin,id:3918,x:32293,y:32469,varname:node_3918,prsc:2|IN-1800-OUT;n:type:ShaderForge.SFN_RemapRange,id:8161,x:31875,y:32430,varname:node_8161,prsc:2,frmn:0,frmx:1,tomn:0,tomx:3.14|IN-9905-OUT;n:type:ShaderForge.SFN_Power,id:9749,x:32477,y:32590,varname:node_9749,prsc:2|VAL-3918-OUT,EXP-5039-OUT;n:type:ShaderForge.SFN_Slider,id:6763,x:31664,y:32816,ptovrint:False,ptlb:width,ptin:_width,varname:node_6763,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:1,cur:3.374507,max:10;n:type:ShaderForge.SFN_Exp,id:5039,x:32217,y:32717,varname:node_5039,prsc:2,et:0|IN-2422-OUT;n:type:ShaderForge.SFN_RemapRange,id:2422,x:32024,y:32717,varname:node_2422,prsc:2,frmn:1,frmx:10,tomn:10,tomx:1|IN-6763-OUT;n:type:ShaderForge.SFN_Color,id:5531,x:32470,y:33020,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_5531,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:0.9926471,c2:0.3357483,c3:0.3357483,c4:1;n:type:ShaderForge.SFN_ValueProperty,id:7741,x:32470,y:32926,ptovrint:False,ptlb:value,ptin:_value,varname:node_7741,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:2;n:type:ShaderForge.SFN_Multiply,id:7265,x:32930,y:32729,varname:node_7265,prsc:2|A-3683-OUT,B-7741-OUT,C-5531-RGB;n:type:ShaderForge.SFN_Add,id:8606,x:33194,y:32511,varname:node_8606,prsc:2|A-2424-RGB,B-7265-OUT;n:type:ShaderForge.SFN_Add,id:1800,x:32112,y:32469,varname:node_1800,prsc:2|A-8161-OUT,B-2196-OUT;n:type:ShaderForge.SFN_Slider,id:2196,x:31664,y:32650,ptovrint:False,ptlb:Offset,ptin:_Offset,varname:node_2196,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-3.14,cur:-0.6366364,max:3.14;n:type:ShaderForge.SFN_Clamp,id:3683,x:32685,y:32706,varname:node_3683,prsc:2|IN-9749-OUT,MIN-8943-OUT,MAX-7582-OUT;n:type:ShaderForge.SFN_Vector1,id:8943,x:32405,y:32761,varname:node_8943,prsc:2,v1:0.01;n:type:ShaderForge.SFN_Vector1,id:7582,x:32405,y:32832,varname:node_7582,prsc:2,v1:1;n:type:ShaderForge.SFN_Lerp,id:9905,x:31656,y:32364,varname:node_9905,prsc:2|A-5881-U,B-5881-V,T-340-OUT;n:type:ShaderForge.SFN_RemapRange,id:340,x:31469,y:32463,varname:node_340,prsc:2,frmn:0,frmx:90,tomn:0,tomx:1|IN-5876-OUT;n:type:ShaderForge.SFN_Slider,id:5876,x:31102,y:32506,ptovrint:False,ptlb:angle,ptin:_angle,varname:node_5876,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:90;proporder:2424-6763-5531-7741-2196-5876;pass:END;sub:END;*/

Shader "Shader Forge/ScanLight" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _width ("width", Range(1, 10)) = 3.374507
        [HDR]_Color ("Color", Color) = (0.9926471,0.3357483,0.3357483,1)
        _value ("value", Float ) = 2
        _Offset ("Offset", Range(-3.14, 3.14)) = -0.6366364
        _angle ("angle", Range(0, 90)) = 0
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _width;
            uniform float4 _Color;
            uniform float _value;
            uniform float _Offset;
            uniform float _angle;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                UNITY_FOG_COORDS(1)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 finalColor = (_MainTex_var.rgb+(clamp(pow(sin(((lerp(i.uv0.r,i.uv0.g,(_angle*0.01111111+0.0))*3.14+0.0)+_Offset)),exp((_width*-1.0+11.0))),0.01,1.0)*_value*_Color.rgb));
                fixed4 finalRGBA = fixed4(finalColor,_MainTex_var.a);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
