

Shader "Unlit/DropsCameraShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        //drop("drop", Vector) = (0,0,0)
        //size("size", Vector) = (1,1,1)
        
        
        
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            // #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {                
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct vertex_to_fragment
            {
                float2 uv : TEXCOORD0;               
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            
            float dropsX [64]; 
            float dropsY [64]; 
            float dropsSizeX [64];
            float dropsSizeY [64];
            
            
            

            vertex_to_fragment vert (appdata v)
            {
                vertex_to_fragment o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                
                return o;
            }

            fixed4 calc_drop(float2 uv, float2 drop_size, float2 drop_position, fixed4 col)
            {
                float2 dist =uv-drop_position;
                float elliptic_dist = dist.x*dist.x/(drop_size.x*drop_size.x)+dist.y*dist.y/(drop_size.y*drop_size.y)-1;                
                float2 uv_opposite = drop_position - dist * -elliptic_dist;
                fixed4 col_opposite = tex2D(_MainTex, uv_opposite);

                return lerp(col_opposite,col, clamp(elliptic_dist+1,0,1));
                
                //if(elliptic_dist >= 0)
                //    return col;
                //return col_opposite;
            }
            
            fixed4 frag (vertex_to_fragment from_vertex) : SV_Target
            {
                float2 uv = from_vertex.uv;
                fixed4 col = tex2D(_MainTex, uv);
                float2 drop;                    
                float2 size;
                for(int i=0; i<64 ; i++)
                {
                    if(dropsSizeX[i]<0.001 || dropsSizeY[i]<0.001) continue; // descarto las gotas demaciado chiquitas
                    
                    
                    drop.x = dropsX[i];
                    drop.y = dropsY[i];
                    size.x = dropsSizeX[i];
                    size.y = dropsSizeY[i];
                    col = calc_drop(uv ,size,drop,col);                    
                }
                
                
                return col;
               
                
            }
            ENDCG
        }
    }
}
