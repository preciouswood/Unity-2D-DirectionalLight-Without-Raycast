Shader "Unlit/ShadowSamplerShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }


            fixed4 frag (v2f i) : Color
            {
				// distance of this pixel from the center
				half distance = i.uv.x;
				//distance *= 128;

				//apply a 2-pixel bias
				distance -= 0.0025;

				//distance stored in the shadow map
				half shadowMapDistance = tex2D(_MainTex,fixed2( 0.5 , i.uv.y)).r;


				//if distance to this pixel is lower than distance from shadowMap,
				//then we are not in shadow
				half light = distance < shadowMapDistance ? 1 : 0;
				half4 result = light;
				return result;
            }
            ENDCG
        }
    }
}
