// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "GoldLeaf"
{
	Properties
	{
		_Foil("Foil", 2D) = "white" {}
		_CloudNoise("Cloud Noise", 2D) = "white" {}
		_Step("Step", Range( 0 , 0.5)) = 0.3
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
			
			uniform sampler2D _Foil;
			uniform sampler2D _CloudNoise;
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

				float2 uv_MainTex = i.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode2 = tex2D( _MainTex, uv_MainTex );
				float cos15 = cos( 0.01 * _Time.y );
				float sin15 = sin( 0.01 * _Time.y );
				float2 rotator15 = mul( ase_ppsScreenPosFragNorm.xy - float2( 1,1 ) , float2x2( cos15 , -sin15 , sin15 , cos15 )) + float2( 1,1 );
				float cos13 = cos( -0.01 * _Time.y );
				float sin13 = sin( -0.01 * _Time.y );
				float2 rotator13 = mul( ase_ppsScreenPosFragNorm.xy - float2( 1,1 ) , float2x2( cos13 , -sin13 , sin13 , cos13 )) + float2( 1,1 );
				float4 temp_output_17_0 = ( tex2D( _CloudNoise, rotator15 ) * tex2D( _CloudNoise, rotator13 ) );
				float temp_output_3_0_g1 = ( _Step - tex2DNode2.r );
				float temp_output_8_0 = saturate( ( temp_output_3_0_g1 / fwidth( temp_output_3_0_g1 ) ) );
				float4 lerpResult24 = lerp( tex2DNode2 , tex2D( _Foil, ( ase_ppsScreenPosFragNorm + temp_output_17_0 ).xy ) , ( step( (temp_output_17_0).r , 0.2 ) * temp_output_8_0 ));
				

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
653;262;1294;510;1744.337;1097.514;1.387494;True;True
Node;AmplifyShaderEditor.ScreenPosInputsNode;23;-1499.604,-1245.291;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;11;-1166.381,-1071.073;Float;True;Property;_CloudNoise;Cloud Noise;1;0;Create;True;0;0;True;0;19d47ac925e332049b84ec563c22a94d;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RotatorNode;15;-1158.796,-856.888;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;2;FLOAT;0.01;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;13;-1158.752,-544.799;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;2;FLOAT;-0.01;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;12;-777.2961,-885.8821;Float;True;Property;_Noise;Noise;1;0;Create;True;0;0;False;0;19d47ac925e332049b84ec563c22a94d;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;10;-780.9033,-574.1138;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;5ffe02d4f1328cd419389a6fd1568d1b;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-445.7619,-717.7723;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-609.3262,-142.7843;Float;False;Property;_Step;Step;2;0;Create;True;0;0;False;0;0.3;0.5;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-256.6986,144.6423;Float;True;Global;_MainTex;_MainTex;0;0;Create;True;0;0;False;0;None;;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;29;-413.1351,-389.442;Float;False;True;False;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;8;-385.1003,-161.8575;Float;False;Step Antialiasing;-1;;1;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;31;-149.5703,-390.4055;Float;False;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-343.8748,-1050.221;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-2.625691,-382.5731;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-78.08986,-958.0507;Float;True;Property;_Foil;Foil;0;0;Create;True;0;0;True;0;5ffe02d4f1328cd419389a6fd1568d1b;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;24;387.4588,-217.0483;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;25;304.6699,19.94701;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;678.571,-241.2438;Float;False;True;2;Float;ASEMaterialInspector;0;9;GoldLeaf;32139be9c1eb75640a847f011acf3bcf;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;True;2;False;-1;False;False;True;2;False;-1;True;7;False;-1;False;False;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;1;0;FLOAT4;0,0,0,0;False;0
WireConnection;15;0;23;0
WireConnection;13;0;23;0
WireConnection;12;0;11;0
WireConnection;12;1;15;0
WireConnection;10;0;11;0
WireConnection;10;1;13;0
WireConnection;17;0;12;0
WireConnection;17;1;10;0
WireConnection;29;0;17;0
WireConnection;8;1;2;0
WireConnection;8;2;9;0
WireConnection;31;0;29;0
WireConnection;33;0;23;0
WireConnection;33;1;17;0
WireConnection;26;0;31;0
WireConnection;26;1;8;0
WireConnection;7;1;33;0
WireConnection;24;0;2;0
WireConnection;24;1;7;0
WireConnection;24;2;26;0
WireConnection;25;0;8;0
WireConnection;1;0;24;0
ASEEND*/
//CHKSM=5FB8F36770936754C439B882B35BA271209CBF29