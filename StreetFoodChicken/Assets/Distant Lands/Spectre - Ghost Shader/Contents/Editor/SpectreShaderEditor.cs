using UnityEngine;
using UnityEditor;


public class SpectreShaderEditor : ShaderGUI
{


    bool baseSettings;
    bool noiseSettings;
    bool colorSettings;
    bool advancedSettings;
    bool ghostSettings;
    bool ghostBlockSettings;
    bool fadeSettings;



    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {


        GUIStyle foldoutStyle = new GUIStyle(GUI.skin.GetStyle("toolbarPopup"));
        foldoutStyle.fontStyle = FontStyle.Bold;
        foldoutStyle.margin = new RectOffset(30, 10, 5, 5);

        GUIStyle titleStyle = new GUIStyle(GUI.skin.GetStyle("boldLabel"));
        foldoutStyle.fontStyle = FontStyle.Bold;


        //Rect space = new Rect(0, 0, EditorGUIUtility.currentViewWidth, EditorGUIUtility.currentViewWidth * 0.15f);

        //EditorGUILayout.Space(space.height);

        //Texture banner = (Texture)AssetDatabase.LoadAssetAtPath("Assets/Distant Lands/Lumen - Stylized Light Effects/Contents/Scripts/Editor/Icons/Titlebar.png", typeof(Texture));

        //GUI.DrawTexture(space, banner);


        colorSettings = EditorGUILayout.BeginFoldoutHeaderGroup(colorSettings, "    Main Settings", foldoutStyle);
        EditorGUILayout.EndFoldoutHeaderGroup();
        if (colorSettings)
        {
            EditorGUI.indentLevel++;
            MaterialProperty colorProperty = ShaderGUI.FindProperty("_MainColor", properties);
            materialEditor.ShaderProperty(colorProperty, colorProperty.displayName);
            EditorGUI.indentLevel++;
            MaterialProperty texture = ShaderGUI.FindProperty("_Texture", properties);
            materialEditor.TexturePropertySingleLine(new GUIContent("Main Texture"), texture);
            EditorGUI.indentLevel--;
            EditorGUILayout.Space();

            EditorGUILayout.LabelField("Vertical Fading", titleStyle);
            MaterialProperty verticalFading = ShaderGUI.FindProperty("_UseVerticalFading", properties);
            materialEditor.ShaderProperty(verticalFading, verticalFading.displayName);
            EditorGUI.BeginDisabledGroup(verticalFading.floatValue == 0);
            EditorGUI.indentLevel++;
            MaterialProperty verticalFadingScale = ShaderGUI.FindProperty("_VerticalFadingScale", properties);
            materialEditor.ShaderProperty(verticalFadingScale, "Scale");
            MaterialProperty verticalFadingOffset = ShaderGUI.FindProperty("_VerticalFadingOffset", properties);
            materialEditor.ShaderProperty(verticalFadingOffset, "Offset");
            MaterialProperty verticalFadingBlend = ShaderGUI.FindProperty("_VerticalFadeBlending", properties);
            materialEditor.ShaderProperty(verticalFadingBlend, "Blend");
            EditorGUI.indentLevel--;
            EditorGUI.EndDisabledGroup();


            EditorGUI.indentLevel--;
        }

        ghostSettings = EditorGUILayout.BeginFoldoutHeaderGroup(ghostSettings, "    Ghosting Settings", foldoutStyle);
        EditorGUILayout.EndFoldoutHeaderGroup();
        if (ghostSettings)
        {
            EditorGUI.indentLevel++;
            EditorGUILayout.Space(5);
            EditorGUILayout.LabelField("Main Ghosting Settings", titleStyle);
            EditorGUI.indentLevel++;
            MaterialProperty ghostColor = FindProperty("_GhostingColor", properties);
            materialEditor.ShaderProperty(ghostColor, ghostColor.displayName);
            MaterialProperty useAlbedo = FindProperty("_UseAlbedoForGhostColor", properties);
            materialEditor.ShaderProperty(useAlbedo, useAlbedo.displayName);
            MaterialProperty startGhostFromFullAlpha = FindProperty("_StartGhostFromFullAlpha", properties);
            materialEditor.ShaderProperty(startGhostFromFullAlpha, "Starting Alpha");
            MaterialProperty fadeToBlack = FindProperty("_FadeToBlack", properties);
            materialEditor.ShaderProperty(fadeToBlack, fadeToBlack.displayName);
            EditorGUILayout.Space();
            EditorGUI.indentLevel--;
            EditorGUILayout.Space(5);
            EditorGUILayout.LabelField("Vertical Ghosting", titleStyle);
            {
                EditorGUI.indentLevel++;
                MaterialProperty method = FindProperty("_VerticalGhosting", properties);
                materialEditor.ShaderProperty(method, "Application Method");
                EditorGUI.BeginDisabledGroup(method.floatValue == 0);
                MaterialProperty blend = FindProperty("_VerticalGhostBlending", properties);
                materialEditor.ShaderProperty(blend, "Blending");
                MaterialProperty scale = FindProperty("_VerticalGhostingScale", properties);
                materialEditor.ShaderProperty(scale, "Scale");
                MaterialProperty offset = FindProperty("_VerticalGhostingOffset", properties);
                materialEditor.ShaderProperty(offset, "Offset");
                EditorGUI.EndDisabledGroup();
                EditorGUILayout.Space();
                EditorGUI.indentLevel--;
            }

            EditorGUILayout.LabelField("Normal Based Ghosting", titleStyle);
            {
                EditorGUI.indentLevel++;
                MaterialProperty method = FindProperty("_NormalGhosting", properties);
                materialEditor.ShaderProperty(method, "Application Method");
                EditorGUI.BeginDisabledGroup(method.floatValue == 0);
                MaterialProperty blend = FindProperty("_NormalGhostBlending", properties);
                materialEditor.ShaderProperty(blend, "Blending");
                MaterialProperty scale = FindProperty("_NormalGhostingScale", properties);
                materialEditor.ShaderProperty(scale, "Scale");
                MaterialProperty offset = FindProperty("_NormalGhostingOffset", properties);
                materialEditor.ShaderProperty(offset, "Offset");
                EditorGUI.EndDisabledGroup();
                EditorGUILayout.Space();
                EditorGUI.indentLevel--;
            }

            EditorGUILayout.LabelField("Fresnel Ghosting", titleStyle);
            {
                EditorGUI.indentLevel++;
                MaterialProperty method = FindProperty("_FresnelGhosting", properties);
                materialEditor.ShaderProperty(method, "Application Method");
                EditorGUI.BeginDisabledGroup(method.floatValue == 0);
                MaterialProperty blend = FindProperty("_FresnelGhostBlending", properties);
                materialEditor.ShaderProperty(blend, "Blending");
                MaterialProperty scale = FindProperty("_FresnelScale", properties);
                materialEditor.ShaderProperty(scale, "Scale");
                MaterialProperty bias = FindProperty("_FresnelBias", properties);
                materialEditor.ShaderProperty(bias, "Bias");
                MaterialProperty power = FindProperty("_FresnelPower", properties);
                materialEditor.ShaderProperty(power, "Power");
                EditorGUI.EndDisabledGroup();
                EditorGUILayout.Space();
                EditorGUI.indentLevel--;
            }


            EditorGUILayout.LabelField("Voronoi Ghosting", titleStyle);
            {
                EditorGUI.indentLevel++;
                MaterialProperty method = FindProperty("_VoronoiGhosting", properties);
                materialEditor.ShaderProperty(method, "Application Method");
                EditorGUI.BeginDisabledGroup(method.floatValue == 0);
                MaterialProperty blend = FindProperty("_VoronoiGhostBlending", properties);
                materialEditor.ShaderProperty(blend, "Blending");
                MaterialProperty scale = FindProperty("_VoronoiNoiseScale", properties);
                materialEditor.ShaderProperty(scale, "Scale");
                MaterialProperty speed = FindProperty("_VoronoiNoiseSpeed", properties);
                materialEditor.ShaderProperty(speed, "Speed");
                EditorGUI.EndDisabledGroup();
                EditorGUILayout.Space();
                EditorGUI.indentLevel--;
            }

            EditorGUILayout.LabelField("Perlin Ghosting", titleStyle);
            {
                EditorGUI.indentLevel++;
                MaterialProperty method = FindProperty("_PerlinGhosting", properties);
                materialEditor.ShaderProperty(method, "Application Method");
                EditorGUI.BeginDisabledGroup(method.floatValue == 0);
                MaterialProperty blend = FindProperty("_PerlinGhostBlending", properties);
                materialEditor.ShaderProperty(blend, "Blending");
                MaterialProperty scale = FindProperty("_PerlinNoiseScale", properties);
                materialEditor.ShaderProperty(scale, "Scale");
                MaterialProperty speed = FindProperty("_PerlinNoiseSpeed", properties);
                materialEditor.ShaderProperty(speed, "Speed");
                EditorGUI.EndDisabledGroup();
                EditorGUILayout.Space();
                EditorGUI.indentLevel--;
            }
            EditorGUI.indentLevel--;
        }

        fadeSettings = EditorGUILayout.BeginFoldoutHeaderGroup(fadeSettings, "    Fading Settings", foldoutStyle);
        EditorGUILayout.EndFoldoutHeaderGroup();
        if (fadeSettings)
        {
            EditorGUI.indentLevel++;
            MaterialProperty useCameraDepth = ShaderGUI.FindProperty("_UseCameraDepthFade", properties);
            materialEditor.ShaderProperty(useCameraDepth, useCameraDepth.displayName);
            EditorGUI.indentLevel++;
            EditorGUI.BeginDisabledGroup(useCameraDepth.floatValue != 1);
            MaterialProperty cameraDepthStart = ShaderGUI.FindProperty("_CameraDepthFadeStart", properties);
            materialEditor.ShaderProperty(cameraDepthStart, cameraDepthStart.displayName);
            MaterialProperty cameraDepthEnd = ShaderGUI.FindProperty("_CameraDepthFadeEnd", properties);
            materialEditor.ShaderProperty(cameraDepthEnd, cameraDepthEnd.displayName);
            EditorGUILayout.Space();
            EditorGUI.indentLevel--;
            EditorGUI.EndDisabledGroup();

            MaterialProperty useCameraDistance = ShaderGUI.FindProperty("_UseCameraDistanceFade", properties);
            materialEditor.ShaderProperty(useCameraDistance, useCameraDistance.displayName);
            EditorGUI.indentLevel++;
            EditorGUI.BeginDisabledGroup(useCameraDistance.floatValue != 1);
            MaterialProperty cameraDistanceStart = ShaderGUI.FindProperty("_CameraDistanceFadeStart", properties);
            materialEditor.ShaderProperty(cameraDistanceStart, cameraDistanceStart.displayName);
            MaterialProperty cameraDistanceEnd = ShaderGUI.FindProperty("_CameraDistanceFadeEnd", properties);
            materialEditor.ShaderProperty(cameraDistanceEnd, cameraDistanceEnd.displayName);
            EditorGUILayout.Space();
            EditorGUI.indentLevel--;
            EditorGUI.EndDisabledGroup();

            MaterialProperty useSceneDepth = ShaderGUI.FindProperty("_UseSceneDepthFade", properties);
            materialEditor.ShaderProperty(useSceneDepth, useSceneDepth.displayName);
            EditorGUI.indentLevel++;
            EditorGUI.BeginDisabledGroup(useSceneDepth.floatValue != 1);
            MaterialProperty sceneDepthStart = ShaderGUI.FindProperty("_DepthFadeStartDistance", properties);
            materialEditor.ShaderProperty(sceneDepthStart, sceneDepthStart.displayName);
            MaterialProperty sceneDepthEnd = ShaderGUI.FindProperty("_DepthFadeEndDistance", properties);
            materialEditor.ShaderProperty(sceneDepthEnd, sceneDepthEnd.displayName);
            EditorGUILayout.Space();
            EditorGUI.indentLevel--;
            EditorGUI.EndDisabledGroup();
            EditorGUI.indentLevel--;

        }

        noiseSettings = EditorGUILayout.BeginFoldoutHeaderGroup(noiseSettings, "    Mesh Deformation", foldoutStyle);
        EditorGUILayout.EndFoldoutHeaderGroup();
        if (noiseSettings)
        {
            EditorGUI.indentLevel++;
            MaterialProperty useNoise = FindProperty("_UseMeshNoise", properties);
            materialEditor.ShaderProperty(useNoise, useNoise.displayName);

            EditorGUI.indentLevel++;
            EditorGUI.BeginDisabledGroup(useNoise.floatValue == 0);

            EditorGUILayout.LabelField("Mesh Noise Settings", titleStyle);
            MaterialProperty scale = ShaderGUI.FindProperty("_MeshNoiseScale", properties);
            materialEditor.ShaderProperty(scale, scale.displayName);
            MaterialProperty speed = ShaderGUI.FindProperty("_MeshNoiseSpeed", properties);
            materialEditor.ShaderProperty(speed, speed.displayName);
            MaterialProperty amp = ShaderGUI.FindProperty("_FinalNoiseAmplitude", properties);
            materialEditor.ShaderProperty(amp, "Mesh Noise Amount");
            EditorGUILayout.Space();

            EditorGUILayout.LabelField("Channel Settings", titleStyle);
            MaterialProperty noiseAmp1 = FindProperty("_NoiseAmplitude1", properties);
            materialEditor.ShaderProperty(noiseAmp1, noiseAmp1.displayName);
            MaterialProperty noiseAmp2 = FindProperty("_NoiseAmplitude2", properties);
            materialEditor.ShaderProperty(noiseAmp2, noiseAmp2.displayName);
            EditorGUILayout.Space();


            EditorGUILayout.LabelField("Stepping Settings", titleStyle);
            MaterialProperty fps = FindProperty("_MeshNoiseFPS", properties);
            materialEditor.ShaderProperty(fps, fps.displayName);
            MaterialProperty cohesion = FindProperty("_MeshNoiseCohesion", properties);
            materialEditor.ShaderProperty(cohesion, cohesion.displayName);
            MaterialProperty spread = FindProperty("_MeshNoiseSpread", properties);
            materialEditor.ShaderProperty(spread, spread.displayName);
            EditorGUILayout.Space();
            EditorGUI.EndDisabledGroup();
            EditorGUI.indentLevel--;

            EditorGUI.indentLevel--;
        }


        advancedSettings = EditorGUILayout.BeginFoldoutHeaderGroup(advancedSettings, "    Clipping Settings", foldoutStyle);
        EditorGUILayout.EndFoldoutHeaderGroup();
        if (advancedSettings)
        {
            EditorGUI.indentLevel++;
            MaterialProperty useClipping = FindProperty("_UseClipping", properties);
            materialEditor.ShaderProperty(useClipping, useClipping.displayName);

            EditorGUI.indentLevel++;
            EditorGUI.BeginDisabledGroup(useClipping.floatValue == 0);

            MaterialProperty clip = FindProperty("_Clipping", properties);
            materialEditor.ShaderProperty(clip, "Clipping Threshold");
            MaterialProperty clipToMaxAlpha = FindProperty("_ClipToMaxAlpha", properties);
            materialEditor.ShaderProperty(clipToMaxAlpha, clipToMaxAlpha.displayName);
            EditorGUI.indentLevel--;
            EditorGUI.EndDisabledGroup();
            EditorGUILayout.Space();

            EditorGUI.indentLevel--;
        }

    }
}