// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Distant Lands/Spectre/Unlit Spectre"
{
	Properties
	{
		[PerRendererData]_CameraDistanceFadeStart("Camera Distance Fade Start", Float) = 20
		[PerRendererData]_CameraDistanceFadeEnd("Camera Distance Fade End", Float) = 30
		[HDR]_GhostingColor("Ghosting Color", Color) = (1,1,1,1)
		_StartGhostFromFullAlpha("Start Ghost From Full Alpha", Range( 0 , 1)) = 1
		[Enum(Disabled,0,Add,1,Multiply,2,Subtract,3,Lighten,4,Darken,5,Override,6)]_NormalGhosting("Normal Ghosting", Float) = 1
		_NormalGhostBlending("Normal Ghost Blending", Range( 0 , 1)) = 1
		_NormalGhostingScale("Normal Ghosting Scale", Range( 0 , 2)) = 1
		_NormalGhostingOffset("Normal Ghosting Offset", Range( -1 , 1)) = 0
		[Enum(Disabled,0,Add,1,Multiply,2,Subtract,3,Lighten,4,Darken,5,Override,6)]_VerticalGhosting("Vertical Ghosting", Float) = 1
		_PerlinGhostBlending("Perlin Ghost Blending", Range( 0 , 1)) = 1
		_VoronoiGhostBlending("Voronoi Ghost Blending", Range( 0 , 1)) = 1
		_VerticalGhostBlending("Vertical Ghost Blending", Range( 0 , 1)) = 1
		_VerticalGhostingScale("Vertical Ghosting Scale", Range( 0 , 10)) = 1
		_VerticalGhostingOffset("Vertical Ghosting Offset", Range( -2 , 2)) = 0
		[Enum(Disabled,0,Add,1,Multiply,2,Subtract,3,Lighten,4,Darken,5,Override,6)]_VoronoiGhosting("Voronoi Ghosting", Float) = 1
		[Enum(Disabled,0,Add,1,Multiply,2,Subtract,3,Lighten,4,Darken,5,Override,6)]_PerlinGhosting("Perlin Ghosting", Float) = 1
		[PerRendererData][Toggle]_UseCameraDepthFade("Use Camera Depth Fade", Float) = 1
		[Enum(Disabled,0,Add,1,Multiply,2,Subtract,3,Lighten,4,Darken,5,Override,6)]_FresnelGhosting("Fresnel Ghosting", Float) = 1
		[PerRendererData][Toggle]_UseCameraDistanceFade("Use Camera Distance Fade", Float) = 1
		_FresnelGhostBlending("Fresnel Ghost Blending", Range( 0 , 1)) = 1
		_FresnelBias("Fresnel Bias", Range( 0 , 1)) = 0
		[PerRendererData]_CameraDepthFadeStart("Camera Depth Fade Start", Float) = 0
		[PerRendererData]_CameraDepthFadeEnd("Camera Depth Fade End", Float) = 2
		_FresnelScale("Fresnel Scale", Range( 0 , 2)) = 1
		_FresnelPower("Fresnel Power", Range( 0 , 10)) = 1
		[PerRendererData][Toggle]_UseSceneDepthFade("Use Scene Depth Fade", Float) = 1
		[ShowAsVector3Field]_NoiseAmplitude1("Noise Amplitude 1", Vector) = (1,1,1,0)
		_MainColor("Main Color", Color) = (1,1,1,1)
		_Texture("Texture", 2D) = "white" {}
		[PerRendererData]_DepthFadeStartDistance("Depth Fade Start Distance", Float) = 0
		[PerRendererData]_DepthFadeEndDistance("Depth Fade End Distance", Float) = 2
		[ShowAsVector3Field]_NoiseAmplitude2("Noise Amplitude 2", Vector) = (1,1,1,0)
		_VerticalFadeBlending("Vertical Fade Blending", Range( 0 , 1)) = 1
		_MeshNoiseSpeed("Mesh Noise Speed", Float) = 1
		_MeshNoiseScale("Mesh Noise Scale", Float) = 1
		_VerticalFadingScale("Vertical Fading Scale", Range( 0 , 10)) = 1
		_MeshNoiseCohesion("Mesh Noise Cohesion", Range( 0 , 1)) = 1
		_VerticalFadingOffset("Vertical Fading Offset", Range( -4 , 4)) = 0
		[Toggle(_USECLIPPING_ON)] _UseClipping("Use Clipping", Float) = 0
		[IntRange]_MeshNoiseFPS("Mesh Noise FPS", Range( 1 , 32)) = 10
		[Toggle(_USEVERTICALFADING_ON)] _UseVerticalFading("Use Vertical Fading", Float) = 0
		_MeshNoiseSpread("Mesh Noise Spread", Range( 0 , 10)) = 1
		_PerlinNoiseScale("Perlin Noise Scale", Range( 0 , 10)) = 3
		_FinalNoiseAmplitude("Final Noise Amplitude", Range( 0 , 4)) = 1
		_Clipping("Clipping", Range( 0 , 1)) = 0.5
		_VoronoiNoiseScale("Voronoi Noise Scale", Range( 0 , 10)) = 3
		[Toggle]_ClipToMaxAlpha("Clip To Max Alpha", Float) = 1
		_VoronoiNoiseSpeed("Voronoi Noise Speed", Range( 0 , 3)) = 0
		[Toggle]_UseAlbedoForGhostColor("Use Albedo For Ghost Color", Float) = 0
		_PerlinNoiseSpeed("Perlin Noise Speed", Range( 0 , 3)) = 0
		[Toggle]_FadeToBlack("Fade To Black", Float) = 0
		[Toggle]_UseMeshNoise("Use Mesh Noise", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _USEVERTICALFADING_ON
		#pragma shader_feature_local _USECLIPPING_ON
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			half ASEVFace : VFACE;
			float4 screenPos;
		};

		uniform float _UseMeshNoise;
		uniform float _MeshNoiseSpeed;
		uniform float _MeshNoiseSpread;
		uniform float _MeshNoiseCohesion;
		uniform float _MeshNoiseFPS;
		uniform float _FinalNoiseAmplitude;
		uniform float3 _NoiseAmplitude1;
		uniform float _MeshNoiseScale;
		uniform float3 _NoiseAmplitude2;
		uniform float4 _MainColor;
		uniform sampler2D _Texture;
		uniform float4 _Texture_ST;
		uniform float _VerticalFadingScale;
		uniform float _VerticalFadingOffset;
		uniform float _VerticalFadeBlending;
		uniform float _FadeToBlack;
		uniform float _UseAlbedoForGhostColor;
		uniform float4 _GhostingColor;
		uniform float _StartGhostFromFullAlpha;
		uniform float _VerticalGhosting;
		uniform float _VerticalGhostingScale;
		uniform float _VerticalGhostingOffset;
		uniform float _VerticalGhostBlending;
		uniform float _NormalGhosting;
		uniform float _NormalGhostingScale;
		uniform float _NormalGhostingOffset;
		uniform float _NormalGhostBlending;
		uniform float _FresnelGhosting;
		uniform float _FresnelBias;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float _FresnelGhostBlending;
		uniform float _VoronoiGhosting;
		uniform float _VoronoiNoiseScale;
		uniform float _VoronoiNoiseSpeed;
		uniform float _VoronoiGhostBlending;
		uniform float _PerlinGhosting;
		uniform float _PerlinNoiseScale;
		uniform float _PerlinNoiseSpeed;
		uniform float _PerlinGhostBlending;
		uniform float _Clipping;
		uniform float _ClipToMaxAlpha;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _UseCameraDepthFade;
		uniform float _CameraDepthFadeStart;
		uniform float _CameraDepthFadeEnd;
		uniform float _UseCameraDistanceFade;
		uniform float _CameraDistanceFadeEnd;
		uniform float _CameraDistanceFadeStart;
		uniform float _UseSceneDepthFade;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DepthFadeStartDistance;
		uniform float _DepthFadeEndDistance;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		float2 voronoihash439( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi439( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash439( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return F1;
		}


		float2 voronoihash438( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi438( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash438( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return F1;
		}


		float2 voronoihash384( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi384( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash384( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return F1;
		}


		float2 voronoihash416( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi416( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash416( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return F1;
		}


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 transform37_g119 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float simplePerlin2D35_g119 = snoise( transform37_g119.xy );
			simplePerlin2D35_g119 = simplePerlin2D35_g119*0.5 + 0.5;
			float mulTime12_g119 = _Time.y * _MeshNoiseSpeed;
			float temp_output_34_0_g119 = ( simplePerlin2D35_g119 + mulTime12_g119 );
			float temp_output_16_0_g119 = ( temp_output_34_0_g119 * _MeshNoiseSpread );
			float temp_output_5_0_g119 = _MeshNoiseFPS;
			float temp_output_449_0 = ( ( temp_output_16_0_g119 - floor( temp_output_16_0_g119 ) ) > _MeshNoiseCohesion ? ( round( ( temp_output_34_0_g119 * temp_output_5_0_g119 ) ) / temp_output_5_0_g119 ) : 0.0 );
			float temp_output_446_0 = ( 1.0 / _MeshNoiseScale );
			float time439 = 4.59;
			float2 voronoiSmoothId0 = 0;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 _Vector2 = float3(1,1,1);
			float2 coords439 = ( ase_vertex3Pos + ( temp_output_449_0 * _Vector2 ) ).xy * ( temp_output_446_0 * 0.4 );
			float2 id439 = 0;
			float2 uv439 = 0;
			float fade439 = 0.5;
			float voroi439 = 0;
			float rest439 = 0;
			for( int it439 = 0; it439 <2; it439++ ){
			voroi439 += fade439 * voronoi439( coords439, time439, id439, uv439, 0,voronoiSmoothId0 );
			rest439 += fade439;
			coords439 *= 2;
			fade439 *= 0.5;
			}//Voronoi439
			voroi439 /= rest439;
			float time438 = 4.59;
			float2 coords438 = ( ase_vertex3Pos + ( float3( -1,-0.5,1 ) * temp_output_449_0 * _Vector2 ) ).xy * temp_output_446_0;
			float2 id438 = 0;
			float2 uv438 = 0;
			float voroi438 = voronoi438( coords438, time438, id438, uv438, 0, voronoiSmoothId0 );
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float3 MeshNoise455 = ( temp_output_449_0 == 0.0 ? float3( 0,0,0 ) : ( _FinalNoiseAmplitude * ( ( ( _NoiseAmplitude1 * min( voroi439 , voroi438 ) ) + ( _NoiseAmplitude2 * voroi438 ) ) / ase_objectScale ) ) );
			v.vertex.xyz += (( _UseMeshNoise )?( MeshNoise455 ):( float3( 0,0,0 ) ));
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_Texture = i.uv_texcoord * _Texture_ST.xy + _Texture_ST.zw;
			float4 RawAlbedo222 = ( _MainColor * tex2D( _Texture, uv_Texture ) );
			float4 break190 = RawAlbedo222;
			float3 appendResult197 = (float3(break190.r , break190.g , break190.b));
			float3 ase_worldPos = i.worldPos;
			float4 transform3_g76 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float temp_output_9_0_g76 = (( float4( ase_worldPos , 0.0 ) - transform3_g76 ).y*_VerticalFadingScale + _VerticalFadingOffset);
			float VerticalFading183 = saturate( temp_output_9_0_g76 );
			float lerpResult316 = lerp( break190.a , ( break190.a * VerticalFading183 ) , _VerticalFadeBlending);
			#ifdef _USEVERTICALFADING_ON
				float staticSwitch189 = lerpResult316;
			#else
				float staticSwitch189 = break190.a;
			#endif
			float3 AlbedoBlock198 = ( appendResult197 * staticSwitch189 );
			float4 break226 = RawAlbedo222;
			float4 appendResult227 = (float4(break226.r , break226.g , break226.b , 1.0));
			float4 break215 = (( _UseAlbedoForGhostColor )?( ( _GhostingColor * appendResult227 ) ):( _GhostingColor ));
			float3 appendResult219 = (float3(break215.r , break215.g , break215.b));
			float GhostColorAlpha237 = _GhostingColor.a;
			float temp_output_10_0_g71 = _StartGhostFromFullAlpha;
			float disabled15_g71 = temp_output_10_0_g71;
			float temp_output_9_0_g71 = _VerticalGhosting;
			float4 transform3_g69 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float temp_output_9_0_g69 = (( float4( ase_worldPos , 0.0 ) - transform3_g69 ).y*_VerticalGhostingScale + _VerticalGhostingOffset);
			float VerticalGhosting390 = saturate( temp_output_9_0_g69 );
			float temp_output_11_0_g71 = VerticalGhosting390;
			float add17_g71 = ( temp_output_10_0_g71 + temp_output_11_0_g71 );
			float multiply18_g71 = ( temp_output_10_0_g71 * temp_output_11_0_g71 );
			float subtract19_g71 = ( temp_output_10_0_g71 - temp_output_11_0_g71 );
			float blendOpSrc46_g71 = temp_output_10_0_g71;
			float blendOpDest46_g71 = temp_output_11_0_g71;
			float lighten47_g71 = ( saturate( 	max( blendOpSrc46_g71, blendOpDest46_g71 ) ));
			float blendOpSrc48_g71 = temp_output_10_0_g71;
			float blendOpDest48_g71 = temp_output_11_0_g71;
			float darken49_g71 = ( saturate( min( blendOpSrc48_g71 , blendOpDest48_g71 ) ));
			float replace25_g71 = temp_output_11_0_g71;
			float lerpResult53_g71 = lerp( disabled15_g71 , ( ( temp_output_9_0_g71 == 0.0 ? disabled15_g71 : 0.0 ) + ( temp_output_9_0_g71 == 1.0 ? add17_g71 : 0.0 ) + ( temp_output_9_0_g71 == 2.0 ? multiply18_g71 : 0.0 ) + ( temp_output_9_0_g71 == 3.0 ? subtract19_g71 : 0.0 ) + ( temp_output_9_0_g71 == 4.0 ? lighten47_g71 : 0.0 ) + ( temp_output_9_0_g71 == 5.0 ? darken49_g71 : 0.0 ) + ( temp_output_9_0_g71 == 6.0 ? replace25_g71 : 0.0 ) ) , _VerticalGhostBlending);
			float temp_output_10_0_g72 = lerpResult53_g71;
			float disabled15_g72 = temp_output_10_0_g72;
			float temp_output_9_0_g72 = _NormalGhosting;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float4 transform380 = mul(unity_ObjectToWorld,float4( ase_vertexNormal , 0.0 ));
			float dotResult365 = dot( float4( float3(0,1,0) , 0.0 ) , transform380 );
			float NormalGhosting403 = saturate( (dotResult365*_NormalGhostingScale + _NormalGhostingOffset) );
			float temp_output_11_0_g72 = NormalGhosting403;
			float add17_g72 = ( temp_output_10_0_g72 + temp_output_11_0_g72 );
			float multiply18_g72 = ( temp_output_10_0_g72 * temp_output_11_0_g72 );
			float subtract19_g72 = ( temp_output_10_0_g72 - temp_output_11_0_g72 );
			float blendOpSrc46_g72 = temp_output_10_0_g72;
			float blendOpDest46_g72 = temp_output_11_0_g72;
			float lighten47_g72 = ( saturate( 	max( blendOpSrc46_g72, blendOpDest46_g72 ) ));
			float blendOpSrc48_g72 = temp_output_10_0_g72;
			float blendOpDest48_g72 = temp_output_11_0_g72;
			float darken49_g72 = ( saturate( min( blendOpSrc48_g72 , blendOpDest48_g72 ) ));
			float replace25_g72 = temp_output_11_0_g72;
			float lerpResult53_g72 = lerp( disabled15_g72 , ( ( temp_output_9_0_g72 == 0.0 ? disabled15_g72 : 0.0 ) + ( temp_output_9_0_g72 == 1.0 ? add17_g72 : 0.0 ) + ( temp_output_9_0_g72 == 2.0 ? multiply18_g72 : 0.0 ) + ( temp_output_9_0_g72 == 3.0 ? subtract19_g72 : 0.0 ) + ( temp_output_9_0_g72 == 4.0 ? lighten47_g72 : 0.0 ) + ( temp_output_9_0_g72 == 5.0 ? darken49_g72 : 0.0 ) + ( temp_output_9_0_g72 == 6.0 ? replace25_g72 : 0.0 ) ) , _NormalGhostBlending);
			float temp_output_10_0_g73 = lerpResult53_g72;
			float disabled15_g73 = temp_output_10_0_g73;
			float temp_output_9_0_g73 = _FresnelGhosting;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_tangentToWorldFast = float3x3(ase_worldTangent.x,ase_worldBitangent.x,ase_worldNormal.x,ase_worldTangent.y,ase_worldBitangent.y,ase_worldNormal.y,ase_worldTangent.z,ase_worldBitangent.z,ase_worldNormal.z);
			float temp_output_4_0_g70 = _FresnelPower;
			float lerpResult3_g70 = lerp( ( -1.0 * temp_output_4_0_g70 ) , temp_output_4_0_g70 , i.ASEVFace);
			float fresnelNdotV1_g70 = dot( mul(ase_tangentToWorldFast,float4( 0,0,1,0 ).rgb), ase_worldViewDir );
			float fresnelNode1_g70 = ( _FresnelBias + _FresnelScale * pow( 1.0 - fresnelNdotV1_g70, lerpResult3_g70 ) );
			float FresnelGhosting362 = saturate( fresnelNode1_g70 );
			float temp_output_11_0_g73 = FresnelGhosting362;
			float add17_g73 = ( temp_output_10_0_g73 + temp_output_11_0_g73 );
			float multiply18_g73 = ( temp_output_10_0_g73 * temp_output_11_0_g73 );
			float subtract19_g73 = ( temp_output_10_0_g73 - temp_output_11_0_g73 );
			float blendOpSrc46_g73 = temp_output_10_0_g73;
			float blendOpDest46_g73 = temp_output_11_0_g73;
			float lighten47_g73 = ( saturate( 	max( blendOpSrc46_g73, blendOpDest46_g73 ) ));
			float blendOpSrc48_g73 = temp_output_10_0_g73;
			float blendOpDest48_g73 = temp_output_11_0_g73;
			float darken49_g73 = ( saturate( min( blendOpSrc48_g73 , blendOpDest48_g73 ) ));
			float replace25_g73 = temp_output_11_0_g73;
			float lerpResult53_g73 = lerp( disabled15_g73 , ( ( temp_output_9_0_g73 == 0.0 ? disabled15_g73 : 0.0 ) + ( temp_output_9_0_g73 == 1.0 ? add17_g73 : 0.0 ) + ( temp_output_9_0_g73 == 2.0 ? multiply18_g73 : 0.0 ) + ( temp_output_9_0_g73 == 3.0 ? subtract19_g73 : 0.0 ) + ( temp_output_9_0_g73 == 4.0 ? lighten47_g73 : 0.0 ) + ( temp_output_9_0_g73 == 5.0 ? darken49_g73 : 0.0 ) + ( temp_output_9_0_g73 == 6.0 ? replace25_g73 : 0.0 ) ) , _FresnelGhostBlending);
			float temp_output_10_0_g74 = lerpResult53_g73;
			float disabled15_g74 = temp_output_10_0_g74;
			float temp_output_9_0_g74 = _VoronoiGhosting;
			float time384 = 0.0;
			float2 voronoiSmoothId0 = 0;
			float2 temp_cast_6 = (( 1.0 / _VoronoiNoiseScale )).xx;
			float mulTime392 = _Time.y * _VoronoiNoiseSpeed;
			float2 uv_TexCoord414 = i.uv_texcoord * temp_cast_6 + ( mulTime392 * float2( 0.05,0.2 ) );
			float2 coords384 = uv_TexCoord414 * 10.0;
			float2 id384 = 0;
			float2 uv384 = 0;
			float voroi384 = voronoi384( coords384, time384, id384, uv384, 0, voronoiSmoothId0 );
			float time416 = 0.0;
			float2 temp_cast_7 = (( 1.6 / _VoronoiNoiseScale )).xx;
			float2 uv_TexCoord409 = i.uv_texcoord * temp_cast_7 + ( mulTime392 * float2( -0.1,0.1 ) );
			float2 coords416 = uv_TexCoord409 * 7.0;
			float2 id416 = 0;
			float2 uv416 = 0;
			float voroi416 = voronoi416( coords416, time416, id416, uv416, 0, voronoiSmoothId0 );
			float VoroNoise347 = ( 1.0 - saturate( ( min( voroi384 , voroi416 ) * 3.0 ) ) );
			float temp_output_11_0_g74 = VoroNoise347;
			float add17_g74 = ( temp_output_10_0_g74 + temp_output_11_0_g74 );
			float multiply18_g74 = ( temp_output_10_0_g74 * temp_output_11_0_g74 );
			float subtract19_g74 = ( temp_output_10_0_g74 - temp_output_11_0_g74 );
			float blendOpSrc46_g74 = temp_output_10_0_g74;
			float blendOpDest46_g74 = temp_output_11_0_g74;
			float lighten47_g74 = ( saturate( 	max( blendOpSrc46_g74, blendOpDest46_g74 ) ));
			float blendOpSrc48_g74 = temp_output_10_0_g74;
			float blendOpDest48_g74 = temp_output_11_0_g74;
			float darken49_g74 = ( saturate( min( blendOpSrc48_g74 , blendOpDest48_g74 ) ));
			float replace25_g74 = temp_output_11_0_g74;
			float lerpResult53_g74 = lerp( disabled15_g74 , ( ( temp_output_9_0_g74 == 0.0 ? disabled15_g74 : 0.0 ) + ( temp_output_9_0_g74 == 1.0 ? add17_g74 : 0.0 ) + ( temp_output_9_0_g74 == 2.0 ? multiply18_g74 : 0.0 ) + ( temp_output_9_0_g74 == 3.0 ? subtract19_g74 : 0.0 ) + ( temp_output_9_0_g74 == 4.0 ? lighten47_g74 : 0.0 ) + ( temp_output_9_0_g74 == 5.0 ? darken49_g74 : 0.0 ) + ( temp_output_9_0_g74 == 6.0 ? replace25_g74 : 0.0 ) ) , _VoronoiGhostBlending);
			float temp_output_10_0_g75 = lerpResult53_g74;
			float disabled15_g75 = temp_output_10_0_g75;
			float temp_output_9_0_g75 = _PerlinGhosting;
			float2 temp_cast_8 = (( 1.0 / _PerlinNoiseScale )).xx;
			float mulTime393 = _Time.y * _PerlinNoiseSpeed;
			float2 uv_TexCoord417 = i.uv_texcoord * temp_cast_8 + ( mulTime393 * float2( 0.05,0.2 ) );
			float simplePerlin2D420 = snoise( uv_TexCoord417 );
			simplePerlin2D420 = simplePerlin2D420*0.5 + 0.5;
			float2 temp_cast_9 = (( 1.6 / _PerlinNoiseScale )).xx;
			float2 uv_TexCoord423 = i.uv_texcoord * temp_cast_9 + ( mulTime393 * float2( -0.1,0.1 ) );
			float simplePerlin2D418 = snoise( uv_TexCoord423 );
			simplePerlin2D418 = simplePerlin2D418*0.5 + 0.5;
			float PerlinNoise370 = ( 1.0 - saturate( ( min( simplePerlin2D420 , simplePerlin2D418 ) * 3.0 ) ) );
			float temp_output_11_0_g75 = PerlinNoise370;
			float add17_g75 = ( temp_output_10_0_g75 + temp_output_11_0_g75 );
			float multiply18_g75 = ( temp_output_10_0_g75 * temp_output_11_0_g75 );
			float subtract19_g75 = ( temp_output_10_0_g75 - temp_output_11_0_g75 );
			float blendOpSrc46_g75 = temp_output_10_0_g75;
			float blendOpDest46_g75 = temp_output_11_0_g75;
			float lighten47_g75 = ( saturate( 	max( blendOpSrc46_g75, blendOpDest46_g75 ) ));
			float blendOpSrc48_g75 = temp_output_10_0_g75;
			float blendOpDest48_g75 = temp_output_11_0_g75;
			float darken49_g75 = ( saturate( min( blendOpSrc48_g75 , blendOpDest48_g75 ) ));
			float replace25_g75 = temp_output_11_0_g75;
			float lerpResult53_g75 = lerp( disabled15_g75 , ( ( temp_output_9_0_g75 == 0.0 ? disabled15_g75 : 0.0 ) + ( temp_output_9_0_g75 == 1.0 ? add17_g75 : 0.0 ) + ( temp_output_9_0_g75 == 2.0 ? multiply18_g75 : 0.0 ) + ( temp_output_9_0_g75 == 3.0 ? subtract19_g75 : 0.0 ) + ( temp_output_9_0_g75 == 4.0 ? lighten47_g75 : 0.0 ) + ( temp_output_9_0_g75 == 5.0 ? darken49_g75 : 0.0 ) + ( temp_output_9_0_g75 == 6.0 ? replace25_g75 : 0.0 ) ) , _PerlinGhostBlending);
			float BlendedFunctions110 = saturate( ( GhostColorAlpha237 * lerpResult53_g75 ) );
			float ClippedAlpha124 = ( BlendedFunctions110 > _Clipping ? ( _ClipToMaxAlpha == 1.0 ? 1.0 : BlendedFunctions110 ) : 0.0 );
			#ifdef _USECLIPPING_ON
				float staticSwitch119 = ClippedAlpha124;
			#else
				float staticSwitch119 = BlendedFunctions110;
			#endif
			float GhostAlpha203 = staticSwitch119;
			float3 GhostingBlock265 = (( _FadeToBlack )?( ( appendResult219 * GhostAlpha203 ) ):( appendResult219 ));
			float3 lerpResult478 = lerp( AlbedoBlock198 , GhostingBlock265 , GhostAlpha203);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 screenColor209 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,ase_grabScreenPos.xy/ase_grabScreenPos.w);
			float AlbedoAlpha191 = staticSwitch189;
			float4 transform9_g122 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float4 transform9_g121 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth4_g118 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth4_g118 = ( screenDepth4_g118 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 );
			float screenDepth17_g120 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth17_g120 = abs( ( screenDepth17_g120 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
			float depthToLinear18_g120 = Linear01Depth(distanceDepth17_g120);
			float FadedFunctions474 = saturate( ( (( _UseCameraDepthFade )?( saturate( (0.0 + (distance( transform9_g122 , float4( _WorldSpaceCameraPos , 0.0 ) ) - _CameraDepthFadeStart) * (1.0 - 0.0) / (_CameraDepthFadeEnd - _CameraDepthFadeStart)) ) ):( 1.0 )) * (( _UseCameraDistanceFade )?( saturate( (0.0 + (distance( transform9_g121 , float4( _WorldSpaceCameraPos , 0.0 ) ) - _CameraDistanceFadeEnd) * (1.0 - 0.0) / (_CameraDistanceFadeStart - _CameraDistanceFadeEnd)) ) ):( 1.0 )) * (( _UseSceneDepthFade )?( ( unity_OrthoParams.w == 0.0 ? saturate( (0.0 + (distanceDepth4_g118 - _DepthFadeStartDistance) * (1.0 - 0.0) / (_DepthFadeEndDistance - _DepthFadeStartDistance)) ) : saturate( ( 1.0 - depthToLinear18_g120 ) ) ) ):( 1.0 )) ) );
			float FinalAlpha127 = ( ( GhostAlpha203 + AlbedoAlpha191 ) * FadedFunctions474 );
			float4 lerpResult208 = lerp( float4( lerpResult478 , 0.0 ) , screenColor209 , saturate( ( 1.0 - FinalAlpha127 ) ));
			o.Emission = lerpResult208.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "SpectreShaderEditor"
}
/*ASEBEGIN
Version=18912
0;1080;2194;606;10149.83;2318.997;9.081988;True;False
Node;AmplifyShaderEditor.CommentaryNode;343;-3184,272;Inherit;False;2015.858;551.0935;;18;421;419;416;415;414;413;409;408;407;405;399;397;396;394;392;391;384;347;Voronoi Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;341;-5248,272;Inherit;False;2019.499;540.1697;;18;423;422;420;418;417;412;411;410;404;402;401;400;398;395;393;386;385;370;Perlin Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;391;-3136,592;Inherit;False;Property;_VoronoiNoiseSpeed;Voronoi Noise Speed;50;0;Create;False;0;0;0;False;0;False;0;1.183;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;395;-5200,592;Inherit;False;Property;_PerlinNoiseSpeed;Perlin Noise Speed;52;0;Create;False;0;0;0;False;0;False;0;2.139;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;394;-2624,656;Inherit;False;Constant;_Vector0;Vector 0;34;0;Create;True;0;0;0;False;0;False;-0.1,0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;397;-2768,400;Inherit;False;Property;_VoronoiNoiseScale;Voronoi Noise Scale;48;0;Create;False;0;0;0;False;0;False;3;2.11;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;342;-4176,1008;Inherit;False;1320.731;398.6297;;9;403;383;380;379;378;373;365;364;363;Normal Ghosting;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;392;-2848,592;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;396;-2624,528;Inherit;False;Constant;_Vector1;Vector 1;34;0;Create;True;0;0;0;False;0;False;0.05,0.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;407;-2464,432;Inherit;False;2;0;FLOAT;1.6;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;393;-4912,592;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;400;-4832,400;Inherit;False;Property;_PerlinNoiseScale;Perlin Noise Scale;45;0;Create;False;0;0;0;False;0;False;3;3.28;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;398;-4688,656;Inherit;False;Constant;_Vector6;Vector 6;34;0;Create;True;0;0;0;False;0;False;-0.1,0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;399;-2464,656;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;2,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalVertexDataNode;378;-4128,1232;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;413;-2464,528;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;2,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;405;-2464,336;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;404;-4688,528;Inherit;False;Constant;_Vector5;Vector 5;34;0;Create;True;0;0;0;False;0;False;0.05,0.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector3Node;379;-4016,1072;Inherit;False;Constant;_NormalGhostingDirection;Normal Ghosting Direction;6;0;Create;True;0;0;0;False;0;False;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;385;-4528,656;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;2,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;414;-2288,416;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;409;-2288,544;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;411;-4528,336;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;345;-2816,1008;Inherit;False;733.9435;278.6406;;4;390;389;388;387;Vertical Ghosting;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;410;-4528,528;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;2,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;412;-4528,432;Inherit;False;2;0;FLOAT;1.6;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;380;-3952,1232;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;388;-2784,1152;Inherit;False;Property;_VerticalGhostingOffset;Vertical Ghosting Offset;14;0;Create;False;0;0;0;False;0;False;0;1;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;387;-2784,1072;Inherit;False;Property;_VerticalGhostingScale;Vertical Ghosting Scale;13;0;Create;False;0;0;0;False;0;False;1;1.77;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;373;-3728,1296;Inherit;False;Property;_NormalGhostingOffset;Normal Ghosting Offset;8;0;Create;False;0;0;0;False;0;False;0;0.546;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;365;-3728,1120;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;364;-3728,1216;Inherit;False;Property;_NormalGhostingScale;Normal Ghosting Scale;7;0;Create;False;0;0;0;False;0;False;1;1.022;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;423;-4352,544;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;384;-2064,416;Inherit;False;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.VoronoiNode;416;-2064,544;Inherit;False;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;7;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;417;-4352,416;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;340;-5248,1008;Inherit;False;1022.744;360.0239;;6;362;353;352;351;350;349;Fresnel Ghosting;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMinOpNode;419;-1888,464;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;389;-2496,1072;Inherit;False;Vertical Ghosting;-1;;69;7b0fa6d336c0cc840bedbc0a74271212;1,15,1;2;16;FLOAT;0;False;17;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;349;-5200,1088;Inherit;False;Property;_FresnelBias;Fresnel Bias;21;0;Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;351;-5200,1168;Inherit;False;Property;_FresnelScale;Fresnel Scale;25;0;Create;False;0;0;0;False;0;False;1;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;350;-5200,1248;Inherit;False;Property;_FresnelPower;Fresnel Power;26;0;Create;False;0;0;0;False;0;False;1;0.98;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;420;-4144,416;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;418;-4144,544;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;363;-3424,1152;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;383;-3232,1152;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;421;-1776,464;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;344;-5245,1520;Inherit;False;3188.551;408.7863;;25;406;382;381;377;376;375;374;372;371;369;368;367;366;361;360;359;358;357;356;355;354;348;346;110;339;Blend Functions;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;390;-2288,1072;Inherit;False;VerticalGhosting;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;352;-4880,1088;Inherit;True;DoubleSidedFresnel;-1;;70;64ed426cf297c5b48b5b91bdfa24d4b5;0;4;10;COLOR;0,0,1,0;False;7;FLOAT;0;False;6;FLOAT;1;False;4;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;401;-3952,464;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;357;-5181,1760;Inherit;False;Property;_StartGhostFromFullAlpha;Start Ghost From Full Alpha;4;0;Create;False;0;7;Disabled;0;Add;1;Multiply;2;Subtract;3;Lighten;4;Darken;5;Override;6;0;True;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;355;-5181,1680;Inherit;False;Property;_VerticalGhostBlending;Vertical Ghost Blending;12;0;Create;False;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;354;-5101,1584;Inherit;False;Property;_VerticalGhosting;Vertical Ghosting;9;1;[Enum];Create;False;0;7;Disabled;0;Add;1;Multiply;2;Subtract;3;Lighten;4;Darken;5;Override;6;0;True;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;353;-4624,1088;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;403;-3088,1152;Inherit;False;NormalGhosting;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;369;-5101,1840;Inherit;False;390;VerticalGhosting;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;422;-3840,464;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;415;-1648,464;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;408;-1520,464;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;368;-4573,1760;Inherit;False;403;NormalGhosting;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;360;-4861,1680;Inherit;False;BlendModes;-1;;71;26ec3cdf9523fad448f0cb939cb82300;0;4;9;FLOAT;0;False;55;FLOAT;0;False;10;FLOAT;0;False;11;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;359;-4669,1600;Inherit;False;Property;_NormalGhostBlending;Normal Ghost Blending;6;0;Create;False;0;0;0;False;0;False;1;0.391;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;402;-3712,464;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;358;-4573,1680;Inherit;False;Property;_NormalGhosting;Normal Ghosting;5;1;[Enum];Create;False;0;7;Disabled;0;Add;1;Multiply;2;Subtract;3;Lighten;4;Darken;5;Override;6;0;True;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;362;-4480,1088;Inherit;False;FresnelGhosting;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;367;-4077,1760;Inherit;False;362;FresnelGhosting;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;264;-3344,-1648;Inherit;False;1949.946;476.4846;;14;265;213;202;204;315;218;219;215;214;227;226;220;237;188;Ghosting Block;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;386;-3584,464;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;348;-4077,1680;Inherit;False;Property;_FresnelGhosting;Fresnel Ghosting;18;1;[Enum];Create;False;0;7;Disabled;0;Add;1;Multiply;2;Subtract;3;Lighten;4;Darken;5;Override;6;0;True;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;381;-4365,1680;Inherit;False;BlendModes;-1;;72;26ec3cdf9523fad448f0cb939cb82300;0;4;9;FLOAT;0;False;55;FLOAT;0;False;10;FLOAT;0;False;11;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;347;-1376,464;Inherit;False;VoroNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;361;-4157,1584;Inherit;False;Property;_FresnelGhostBlending;Fresnel Ghost Blending;20;0;Create;False;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;370;-3440,464;Inherit;False;PerlinNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;356;-3869,1680;Inherit;False;BlendModes;-1;;73;26ec3cdf9523fad448f0cb939cb82300;0;4;9;FLOAT;0;False;55;FLOAT;0;False;10;FLOAT;0;False;11;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;366;-3565,1760;Inherit;False;347;VoroNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;377;-3565,1680;Inherit;False;Property;_VoronoiGhosting;Voronoi Ghosting;15;1;[Enum];Create;False;0;7;Disabled;0;Add;1;Multiply;2;Subtract;3;Lighten;4;Darken;5;Override;6;0;True;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;188;-3088,-1520;Inherit;False;Property;_GhostingColor;Ghosting Color;3;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0.2666667,0.6235294,0.2993882,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;346;-3645,1584;Inherit;False;Property;_VoronoiGhostBlending;Voronoi Ghost Blending;11;0;Create;False;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;372;-3165,1584;Inherit;False;Property;_PerlinGhostBlending;Perlin Ghost Blending;10;0;Create;False;0;0;0;False;0;False;1;0.309;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;382;-3069,1680;Inherit;False;Property;_PerlinGhosting;Perlin Ghosting;16;1;[Enum];Create;False;0;7;Disabled;0;Add;1;Multiply;2;Subtract;3;Lighten;4;Darken;5;Override;6;0;True;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;237;-2800,-1344;Inherit;False;GhostColorAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;406;-3085,1760;Inherit;False;370;PerlinNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;374;-3357,1680;Inherit;False;BlendModes;-1;;74;26ec3cdf9523fad448f0cb939cb82300;0;4;9;FLOAT;0;False;55;FLOAT;0;False;10;FLOAT;0;False;11;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;375;-2877,1680;Inherit;False;BlendModes;-1;;75;26ec3cdf9523fad448f0cb939cb82300;0;4;9;FLOAT;0;False;55;FLOAT;0;False;10;FLOAT;0;False;11;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;339;-2797,1600;Inherit;False;237;GhostColorAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;196;-3360,-1056;Inherit;False;2098.222;455.7998;;17;198;201;318;197;191;189;317;316;180;193;319;190;194;222;175;174;7;Albedo Block;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;371;-2541,1680;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;177;-2400,-432;Inherit;False;741.1627;254.7581;;4;183;181;178;179;Vertical Fading;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;376;-2413,1680;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-3232,-992;Inherit;False;Property;_MainColor;Main Color;29;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.5670214,1,0.4588236,0.772549;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;179;-2368,-288;Inherit;False;Property;_VerticalFadingOffset;Vertical Fading Offset;40;0;Create;True;0;0;0;False;0;False;0;3.78;-4;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;178;-2368,-368;Inherit;False;Property;_VerticalFadingScale;Vertical Fading Scale;38;0;Create;True;0;0;0;False;0;False;1;3.49;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;174;-3312,-816;Inherit;True;Property;_Texture;Texture;30;0;Create;True;0;0;0;False;0;False;-1;None;0a0e8af2869fa45f78e25460db578482;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;424;-6192,-832;Inherit;False;2776.951;875.0591;;31;454;453;452;451;450;449;448;447;446;445;444;443;442;441;440;439;438;437;436;435;434;433;432;431;430;429;428;427;426;425;455;Mesh Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;-2976,-992;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;112;-3360,-432;Inherit;False;908.1516;509.4678;;7;115;120;122;121;108;117;124;Clipping;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;-2285,1680;Inherit;False;BlendedFunctions;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;181;-2080,-368;Inherit;False;Vertical Ghosting;-1;;76;7b0fa6d336c0cc840bedbc0a74271212;1,15,1;2;16;FLOAT;0;False;17;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;183;-1872,-368;Inherit;False;VerticalFading;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;-3296,-80;Inherit;False;110;BlendedFunctions;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;453;-6144,-320;Inherit;False;Property;_MeshNoiseSpread;Mesh Noise Spread;44;0;Create;False;0;0;0;False;0;False;1;10;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;451;-6144,-400;Inherit;False;Property;_MeshNoiseCohesion;Mesh Noise Cohesion;39;0;Create;False;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;450;-6096,-576;Inherit;False;Property;_MeshNoiseSpeed;Mesh Noise Speed;36;0;Create;False;0;0;0;False;0;False;1;3.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;456;-2000,1008;Inherit;False;1384.311;509.6511;;12;458;474;473;472;471;468;466;463;461;460;457;475;Fading Functions;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;222;-2816,-992;Inherit;False;RawAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-3264,-176;Inherit;False;Property;_ClipToMaxAlpha;Clip To Max Alpha;49;1;[Toggle];Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;452;-6144,-480;Inherit;False;Property;_MeshNoiseFPS;Mesh Noise FPS;42;1;[IntRange];Create;False;0;0;0;False;0;False;10;32;1;32;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;-3184,-352;Inherit;False;110;BlendedFunctions;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;220;-3280,-1344;Inherit;False;222;RawAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-3184,-272;Inherit;False;Property;_Clipping;Clipping;47;0;Create;True;0;0;0;False;0;False;0.5;0.244;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;458;-1936,1408;Inherit;False;Orthographic Fade;-1;;120;07ff034ed2c5b5b4783cf486c6ebd7b0;0;0;1;FLOAT;6
Node;AmplifyShaderEditor.BreakToComponentsNode;190;-2544,-992;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;194;-2640,-800;Inherit;False;183;VerticalFading;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OrthoParams;475;-1936,1200;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;449;-5856,-528;Inherit;False;Stepped Time;-1;;119;b482407c5c8467244a6eadf99b789e31;0;4;1;FLOAT;1;False;5;FLOAT;0;False;24;FLOAT;0;False;23;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;457;-1936,1328;Inherit;False;Scene Depth Fade;31;;118;b80e7cce07f3ff241b5ed9e75228c4d5;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;447;-5488,-496;Inherit;False;Constant;_Vector2;Vector 2;22;0;Create;True;0;0;0;False;0;False;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Compare;120;-3056,-192;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;448;-5568,-320;Inherit;False;Property;_MeshNoiseScale;Mesh Noise Scale;37;0;Create;False;0;0;0;False;0;False;1;1.56;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;180;-2592,-704;Inherit;False;Property;_VerticalFadeBlending;Vertical Fade Blending;35;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;461;-1680,1312;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;446;-5344,-336;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;226;-3104,-1344;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WireNode;319;-2340.026,-833.1423;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;115;-2848,-336;Inherit;False;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;443;-5280,-480;Inherit;False;3;3;0;FLOAT3;-1,-0.5,1;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;444;-5472,-736;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;460;-1696,1200;Inherit;False;Camera Distance Fade;0;;121;f992419659205874689e17721bd92798;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;445;-5280,-576;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;193;-2448,-800;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;463;-1696,1088;Inherit;False;Camera Depth Fade;22;;122;b003bbeb8eacda14fa920f9527150e3e;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;317;-2176,-832;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;471;-1472,1200;Inherit;False;Property;_UseCameraDistanceFade;Use Camera Distance Fade;19;0;Create;False;0;0;0;False;1;PerRendererData;False;1;True;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;316;-2304,-800;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;466;-1472,1088;Inherit;False;Property;_UseCameraDepthFade;Use Camera Depth Fade;17;0;Create;False;0;0;0;False;1;PerRendererData;False;1;True;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;468;-1456,1344;Inherit;False;Property;_UseSceneDepthFade;Use Scene Depth Fade;27;0;Create;False;0;0;0;False;1;PerRendererData;False;1;True;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;441;-5216,-336;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;227;-2976,-1344;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;440;-5120,-576;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;442;-5120,-480;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;124;-2688,-336;Inherit;False;ClippedAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;118;-144,-720;Inherit;False;1433.065;316.0273;;9;127;195;192;203;119;126;125;476;477;Final Alpha;1,1,1,1;0;0
Node;AmplifyShaderEditor.VoronoiNode;438;-4960,-448;Inherit;False;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;4.59;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.VoronoiNode;439;-4960,-592;Inherit;False;0;0;1;0;2;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;4.59;False;2;FLOAT;0.3;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.StaticSwitch;189;-2144,-800;Inherit;False;Property;_UseVerticalFading;Use Vertical Fading;43;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-96,-624;Inherit;False;110;BlendedFunctions;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;-96,-544;Inherit;False;124;ClippedAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;472;-1120,1120;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;214;-2800,-1440;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;191;-1840,-800;Inherit;False;AlbedoAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;473;-976,1120;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;437;-4736,-592;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;435;-4784,-480;Inherit;False;Property;_NoiseAmplitude2;Noise Amplitude 2;34;0;Create;True;0;0;0;False;1;ShowAsVector3Field;False;1,1,1;-0.1,0.1,0.3;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;436;-4816,-752;Inherit;False;Property;_NoiseAmplitude1;Noise Amplitude 1;28;0;Create;True;0;0;0;False;1;ShowAsVector3Field;False;1,1,1;0.2,0.5,0.4;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch;119;144,-624;Inherit;False;Property;_UseClipping;Use Clipping;41;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;218;-2640,-1520;Inherit;False;Property;_UseAlbedoForGhostColor;Use Albedo For Ghost Color;51;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;203;368,-624;Inherit;False;GhostAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;474;-832,1120;Inherit;False;FadedFunctions;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;434;-4592,-480;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;433;-4592,-640;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;192;368,-528;Inherit;False;191;AlbedoAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;215;-2384,-1520;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;477;608,-528;Inherit;False;474;FadedFunctions;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;204;-2384,-1600;Inherit;False;203;GhostAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectScaleNode;431;-4400,-464;Inherit;False;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;432;-4400,-560;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;430;-5488,-208;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;195;608,-624;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;219;-2272,-1520;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;427;-4400,-656;Inherit;False;Property;_FinalNoiseAmplitude;Final Noise Amplitude;46;0;Create;False;0;0;0;False;0;False;1;0.15;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;428;-3984,-208;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;197;-2400,-992;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;318;-1829,-893;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;202;-2096,-1584;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;429;-4224,-560;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;476;816,-624;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;425;-4048,-560;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0.2,0.2,0.2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;127;1024,-624;Inherit;False;FinalAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;315;-1920,-1520;Inherit;False;Property;_FadeToBlack;Fade To Black;53;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;201;-1600,-1008;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;426;-3952,-448;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;128;-400,160;Inherit;False;127;FinalAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;265;-1600,-1520;Inherit;False;GhostingBlock;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Compare;454;-3904,-544;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;198;-1472,-1008;Inherit;False;AlbedoBlock;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;210;-240,160;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;455;-3760,-544;Inherit;False;MeshNoise;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;479;-560,-64;Inherit;False;203;GhostAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;266;-560,-144;Inherit;False;265;GhostingBlock;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;199;-560,-224;Inherit;False;198;AlbedoBlock;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;211;-96,160;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;478;-256,-160;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;169;-80,336;Inherit;False;455;MeshNoise;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScreenColorNode;209;-192,-16;Inherit;False;Global;_GrabScreen0;Grab Screen 0;31;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;213;-1728,-1520;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;208;64,-32;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;221;128,336;Inherit;False;Property;_UseMeshNoise;Use Mesh Noise;54;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;370,-2;Float;False;True;-1;2;SpectreShaderEditor;0;0;Unlit;Distant Lands/Spectre/Unlit Spectre;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;1;False;-1;3;False;-1;False;0;Translucent;0.5;True;False;0;False;Opaque;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;32;10;25;False;0.5;False;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;21;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;392;0;391;0
WireConnection;407;1;397;0
WireConnection;393;0;395;0
WireConnection;399;0;392;0
WireConnection;399;1;394;0
WireConnection;413;0;392;0
WireConnection;413;1;396;0
WireConnection;405;1;397;0
WireConnection;385;0;393;0
WireConnection;385;1;398;0
WireConnection;414;0;405;0
WireConnection;414;1;413;0
WireConnection;409;0;407;0
WireConnection;409;1;399;0
WireConnection;411;1;400;0
WireConnection;410;0;393;0
WireConnection;410;1;404;0
WireConnection;412;1;400;0
WireConnection;380;0;378;0
WireConnection;365;0;379;0
WireConnection;365;1;380;0
WireConnection;423;0;412;0
WireConnection;423;1;385;0
WireConnection;384;0;414;0
WireConnection;416;0;409;0
WireConnection;417;0;411;0
WireConnection;417;1;410;0
WireConnection;419;0;384;0
WireConnection;419;1;416;0
WireConnection;389;16;387;0
WireConnection;389;17;388;0
WireConnection;420;0;417;0
WireConnection;418;0;423;0
WireConnection;363;0;365;0
WireConnection;363;1;364;0
WireConnection;363;2;373;0
WireConnection;383;0;363;0
WireConnection;421;0;419;0
WireConnection;390;0;389;0
WireConnection;352;7;349;0
WireConnection;352;6;351;0
WireConnection;352;4;350;0
WireConnection;401;0;420;0
WireConnection;401;1;418;0
WireConnection;353;0;352;0
WireConnection;403;0;383;0
WireConnection;422;0;401;0
WireConnection;415;0;421;0
WireConnection;408;0;415;0
WireConnection;360;9;354;0
WireConnection;360;55;355;0
WireConnection;360;10;357;0
WireConnection;360;11;369;0
WireConnection;402;0;422;0
WireConnection;362;0;353;0
WireConnection;386;0;402;0
WireConnection;381;9;358;0
WireConnection;381;55;359;0
WireConnection;381;10;360;0
WireConnection;381;11;368;0
WireConnection;347;0;408;0
WireConnection;370;0;386;0
WireConnection;356;9;348;0
WireConnection;356;55;361;0
WireConnection;356;10;381;0
WireConnection;356;11;367;0
WireConnection;237;0;188;4
WireConnection;374;9;377;0
WireConnection;374;55;346;0
WireConnection;374;10;356;0
WireConnection;374;11;366;0
WireConnection;375;9;382;0
WireConnection;375;55;372;0
WireConnection;375;10;374;0
WireConnection;375;11;406;0
WireConnection;371;0;339;0
WireConnection;371;1;375;0
WireConnection;376;0;371;0
WireConnection;175;0;7;0
WireConnection;175;1;174;0
WireConnection;110;0;376;0
WireConnection;181;16;178;0
WireConnection;181;17;179;0
WireConnection;183;0;181;0
WireConnection;222;0;175;0
WireConnection;190;0;222;0
WireConnection;449;1;450;0
WireConnection;449;5;452;0
WireConnection;449;24;451;0
WireConnection;449;23;453;0
WireConnection;120;0;121;0
WireConnection;120;3;117;0
WireConnection;461;0;475;4
WireConnection;461;2;457;0
WireConnection;461;3;458;6
WireConnection;446;1;448;0
WireConnection;226;0;220;0
WireConnection;319;0;190;3
WireConnection;115;0;122;0
WireConnection;115;1;108;0
WireConnection;115;2;120;0
WireConnection;443;1;449;0
WireConnection;443;2;447;0
WireConnection;445;0;449;0
WireConnection;445;1;447;0
WireConnection;193;0;190;3
WireConnection;193;1;194;0
WireConnection;317;0;190;3
WireConnection;471;1;460;0
WireConnection;316;0;319;0
WireConnection;316;1;193;0
WireConnection;316;2;180;0
WireConnection;466;1;463;0
WireConnection;468;1;461;0
WireConnection;441;0;446;0
WireConnection;227;0;226;0
WireConnection;227;1;226;1
WireConnection;227;2;226;2
WireConnection;440;0;444;0
WireConnection;440;1;445;0
WireConnection;442;0;444;0
WireConnection;442;1;443;0
WireConnection;124;0;115;0
WireConnection;438;0;442;0
WireConnection;438;2;446;0
WireConnection;439;0;440;0
WireConnection;439;2;441;0
WireConnection;189;1;317;0
WireConnection;189;0;316;0
WireConnection;472;0;466;0
WireConnection;472;1;471;0
WireConnection;472;2;468;0
WireConnection;214;0;188;0
WireConnection;214;1;227;0
WireConnection;191;0;189;0
WireConnection;473;0;472;0
WireConnection;437;0;439;0
WireConnection;437;1;438;0
WireConnection;119;1;125;0
WireConnection;119;0;126;0
WireConnection;218;0;188;0
WireConnection;218;1;214;0
WireConnection;203;0;119;0
WireConnection;474;0;473;0
WireConnection;434;0;435;0
WireConnection;434;1;438;0
WireConnection;433;0;436;0
WireConnection;433;1;437;0
WireConnection;215;0;218;0
WireConnection;432;0;433;0
WireConnection;432;1;434;0
WireConnection;430;0;449;0
WireConnection;195;0;203;0
WireConnection;195;1;192;0
WireConnection;219;0;215;0
WireConnection;219;1;215;1
WireConnection;219;2;215;2
WireConnection;428;0;430;0
WireConnection;197;0;190;0
WireConnection;197;1;190;1
WireConnection;197;2;190;2
WireConnection;318;0;189;0
WireConnection;202;0;219;0
WireConnection;202;1;204;0
WireConnection;429;0;432;0
WireConnection;429;1;431;0
WireConnection;476;0;195;0
WireConnection;476;1;477;0
WireConnection;425;0;427;0
WireConnection;425;1;429;0
WireConnection;127;0;476;0
WireConnection;315;0;219;0
WireConnection;315;1;202;0
WireConnection;201;0;197;0
WireConnection;201;1;318;0
WireConnection;426;0;428;0
WireConnection;265;0;315;0
WireConnection;454;0;426;0
WireConnection;454;3;425;0
WireConnection;198;0;201;0
WireConnection;210;0;128;0
WireConnection;455;0;454;0
WireConnection;211;0;210;0
WireConnection;478;0;199;0
WireConnection;478;1;266;0
WireConnection;478;2;479;0
WireConnection;213;0;315;0
WireConnection;208;0;478;0
WireConnection;208;1;209;0
WireConnection;208;2;211;0
WireConnection;221;1;169;0
WireConnection;0;2;208;0
WireConnection;0;11;221;0
ASEEND*/
//CHKSM=74279C630F52EA9947AD480837F91D8D44E04D7A