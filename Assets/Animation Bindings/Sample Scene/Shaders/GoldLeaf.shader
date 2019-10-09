// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "GoldLeaf"
{
	Properties
	{
		[HDR]_Foil("Foil", 2D) = "white" {}
		_CloudNoise("Cloud Noise", 2D) = "white" {}
		_Step("Step", Range( 0 , 0.5)) = 0.3
		[Normal]_N_Paint("N_Paint", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Cull Off
		ZWrite Off
		ZTest Always
		
		Pass
		{
			CGPROGRAM

			

			#pragma vertex Vert
			#pragma fragment Frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#include "UnityStandardUtils.cginc"

		
			struct ASEAttributesDefault
			{
				float3 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				
			};

			struct ASEVaryingsDefault
			{
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoordStereo : TEXCOORD1;
			#if STEREO_INSTANCING_ENABLED
				uint stereoTargetEyeIndex : SV_RenderTargetArrayIndex;
			#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform sampler2D _CloudNoise;
			uniform sampler2D _N_Paint;
			uniform float4 _N_Paint_ST;
			uniform sampler2D _Foil;
			uniform float _Step;

			
			float2 TransformTriangleVertexToUV (float2 vertex)
			{
				float2 uv = (vertex + 1.0) * 0.5;
				return uv;
			}

			ASEVaryingsDefault Vert( ASEAttributesDefault v  )
			{
				ASEVaryingsDefault o;
				o.vertex = float4(v.vertex.xy, 0.0, 1.0);
				o.texcoord = TransformTriangleVertexToUV (v.vertex.xy);
#if UNITY_UV_STARTS_AT_TOP
				o.texcoord = o.texcoord * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif
				o.texcoordStereo = TransformStereoScreenSpaceTex (o.texcoord, 1.0);

				v.texcoord = o.texcoordStereo;
				float4 ase_ppsScreenPosVertexNorm = float4(o.texcoordStereo,0,1);

				

				return o;
			}

			float4 Frag (ASEVaryingsDefault i  ) : SV_Target
			{
				float4 ase_ppsScreenPosFragNorm = float4(i.texcoordStereo,0,1);

				float cos15 = cos( 0.01 * _Time.y );
				float sin15 = sin( 0.01 * _Time.y );
				float2 rotator15 = mul( ase_ppsScreenPosFragNorm.xy - float2( 1,1 ) , float2x2( cos15 , -sin15 , sin15 , cos15 )) + float2( 1,1 );
				float cos13 = cos( -0.01 * _Time.y );
				float sin13 = sin( -0.01 * _Time.y );
				float2 rotator13 = mul( ase_ppsScreenPosFragNorm.xy - float2( 1,1 ) , float2x2( cos13 , -sin13 , sin13 , cos13 )) + float2( 1,1 );
				float4 temp_output_17_0 = ( tex2D( _CloudNoise, rotator15 ) * tex2D( _CloudNoise, rotator13 ) );
				float4 temp_output_33_0 = ( ase_ppsScreenPosFragNorm + temp_output_17_0 );
				float2 uv_N_Paint = i.texcoord.xy * _N_Paint_ST.xy + _N_Paint_ST.zw;
				float2 temp_output_41_0 = (UnpackScaleNormal( tex2D( _N_Paint, uv_N_Paint ), 0.004 )).xy;
				float4 tex2DNode2 = tex2D( _MainTex, ( ( ( temp_output_33_0 * 0.02 ) + ase_ppsScreenPosFragNorm ) + float4( temp_output_41_0, 0.0 , 0.0 ) ).xy );
				float temp_output_3_0_g1 = ( _Step - tex2DNode2.r );
				float4 lerpResult24 = lerp( tex2DNode2 , ( tex2D( _Foil, temp_output_33_0.xy ) * 2.0 ) , ( step( (temp_output_17_0).r , 0.2 ) * saturate( ( temp_output_3_0_g1 / fwidth( temp_output_3_0_g1 ) ) ) ));
				

				float4 color = lerpResult24;
				
				return color;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16900
466;289;1294;510;1714.415;90.06023;1.11389;True;True
Node;AmplifyShaderEditor.ScreenPosInputsNode;23;-2475.54,-1009.864;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;13;-2091.35,-462.7221;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;2;FLOAT;-0.01;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;15;-2091.394,-774.8112;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;2;FLOAT;0.01;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;11;-2098.979,-988.9961;Float;True;Property;_CloudNoise;Cloud Noise;2;0;Create;True;0;0;True;0;19d47ac925e332049b84ec563c22a94d;19d47ac925e332049b84ec563c22a94d;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;10;-1713.501,-492.0369;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;5ffe02d4f1328cd419389a6fd1568d1b;5ffe02d4f1328cd419389a6fd1568d1b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;-1709.894,-803.8052;Float;True;Property;_Noise;Noise;1;0;Create;True;0;0;False;0;19d47ac925e332049b84ec563c22a94d;19d47ac925e332049b84ec563c22a94d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1378.36,-635.6954;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-986.0479,-919.2058;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-684.8581,416.896;Float;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;False;0;0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-757.0488,183.454;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;40;-1481.051,63.31777;Float;True;Property;_N_Paint;N_Paint;4;1;[Normal];Create;True;0;0;False;0;ed0b64302719eac4798f43bd3634e9bd;ed0b64302719eac4798f43bd3634e9bd;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0.004;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-616.2322,46.90369;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;41;-1109.467,265.1258;Float;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-493.9984,167.9435;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;29;-413.1351,-389.442;Float;False;True;False;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-350.6468,185.7563;Float;True;Global;_MainTex;_MainTex;0;0;Create;True;0;0;False;0;None;;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-707.342,-182.4574;Float;False;Property;_Step;Step;3;0;Create;True;0;0;False;0;0.3;0.5;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;8;-385.1003,-161.8575;Float;False;Step Antialiasing;-1;;1;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-78.08986,-958.0507;Float;True;Property;_Foil;Foil;1;1;[HDR];Create;True;0;0;True;0;5ffe02d4f1328cd419389a6fd1568d1b;5ffe02d4f1328cd419389a6fd1568d1b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;31;-149.5703,-390.4055;Float;False;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;135.8161,-670.1617;Float;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-2.625691,-382.5731;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;246.1321,-816.4106;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-842.9553,323.0255;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;24;387.4588,-217.0483;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;42;-1203.771,517.7413;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;678.571,-241.2438;Float;False;True;2;Float;ASEMaterialInspector;0;2;GoldLeaf;32139be9c1eb75640a847f011acf3bcf;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;True;2;False;-1;False;False;True;2;False;-1;True;7;False;-1;False;False;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;1;0;FLOAT4;0,0,0,0;False;0
WireConnection;13;0;23;0
WireConnection;15;0;23;0
WireConnection;10;0;11;0
WireConnection;10;1;13;0
WireConnection;12;0;11;0
WireConnection;12;1;15;0
WireConnection;17;0;12;0
WireConnection;17;1;10;0
WireConnection;33;0;23;0
WireConnection;33;1;17;0
WireConnection;34;0;33;0
WireConnection;34;1;36;0
WireConnection;37;0;34;0
WireConnection;37;1;23;0
WireConnection;41;0;40;0
WireConnection;44;0;37;0
WireConnection;44;1;41;0
WireConnection;29;0;17;0
WireConnection;2;1;44;0
WireConnection;8;1;2;0
WireConnection;8;2;9;0
WireConnection;7;1;33;0
WireConnection;31;0;29;0
WireConnection;26;0;31;0
WireConnection;26;1;8;0
WireConnection;38;0;7;0
WireConnection;38;1;39;0
WireConnection;43;0;41;0
WireConnection;43;1;42;0
WireConnection;24;0;2;0
WireConnection;24;1;38;0
WireConnection;24;2;26;0
WireConnection;1;0;24;0
ASEEND*/
//CHKSM=AC56FB14AE387B01171DDD27436C6699AC61BAA6