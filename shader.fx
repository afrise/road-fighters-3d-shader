
#include "ReShade.fxh"

float3 deinterlace(float4 vois : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
    bool odd = (texcoord.y * BUFFER_HEIGHT) % 2 >= 1;
    float2 offset = odd ? float2(texcoord.x, texcoord.y+BUFFER_RCP_HEIGHT) : float2(texcoord.x, texcoord.y-BUFFER_RCP_HEIGHT);
    float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;
    float3 color2 = tex2D(ReShade::BackBuffer, offset).rgb;
    if (odd)
    {
        color[0]=color2[0];
    }
    else
    {
        //CYAN [right]
        color[1]=color2[1];
        color[2]=color[1];
    }
        
	return color;
}

technique deinterlace
{
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = deinterlace;
	}
}