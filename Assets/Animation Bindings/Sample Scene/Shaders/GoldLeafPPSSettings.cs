// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( GoldLeafPPSRenderer ), PostProcessEvent.BeforeStack, "GoldLeaf", true )]
public sealed class GoldLeafPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "Foil" )]
	public TextureParameter _Foil = new TextureParameter {  };
	[Tooltip( "Cloud Noise" )]
	public TextureParameter _CloudNoise = new TextureParameter {  };
	[Tooltip( "Step" )]
	public FloatParameter _Step = new FloatParameter { value = 0.3f };
}

public sealed class GoldLeafPPSRenderer : PostProcessEffectRenderer<GoldLeafPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "GoldLeaf" ) );
		if(settings._Foil.value != null) sheet.properties.SetTexture( "_Foil", settings._Foil );
		if(settings._CloudNoise.value != null) sheet.properties.SetTexture( "_CloudNoise", settings._CloudNoise );
		sheet.properties.SetFloat( "_Step", settings._Step );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
