using UnityEngine;
using System;
using System.IO;
using System.Collections.Generic;
using System.Collections;

namespace WriteTxtLog
{

	public static class WriteTxtLogClass
	{


        static string pathFileWrite = @"C:\Code\output.txt";

        static List<string> listOfStrings = new List<string>();

        public static void FunctionWriteDefault()
        {
        	string whatYouWantToWrite = "";



        	listOfStrings.Add(whatYouWantToWrite);

			WriteToFile(pathFileWrite, listOfStrings);

        }

		public static void FunctionWrite()
		{

			listOfStrings.Add(SystemInfo.batteryLevel + "                 batteryLevel");
			listOfStrings.Add(SystemInfo.batteryStatus + "                 batteryStatus");
			listOfStrings.Add(SystemInfo.constantBufferOffsetAlignment + "                 constantBufferOffsetAlignment");
			listOfStrings.Add(SystemInfo.copyTextureSupport + "                 copyTextureSupport");
			listOfStrings.Add(SystemInfo.deviceModel + "                 deviceModel");
			listOfStrings.Add(SystemInfo.deviceName + "                 deviceName");
			listOfStrings.Add(SystemInfo.deviceType + "                 deviceType");
			listOfStrings.Add(SystemInfo.deviceUniqueIdentifier + "                 deviceUniqueIdentifier");
			listOfStrings.Add(SystemInfo.graphicsDeviceID + "                 graphicsDeviceID");
			listOfStrings.Add(SystemInfo.graphicsDeviceName + "                 graphicsDeviceName");
			listOfStrings.Add(SystemInfo.graphicsDeviceType + "                 graphicsDeviceType");
			listOfStrings.Add(SystemInfo.graphicsDeviceVendor + "                 graphicsDeviceVendor");
			listOfStrings.Add(SystemInfo.graphicsDeviceVendorID + "                 graphicsDeviceVendorID");
			listOfStrings.Add(SystemInfo.graphicsDeviceVersion + "                 graphicsDeviceVersion");
			listOfStrings.Add(SystemInfo.graphicsMemorySize + "                 graphicsMemorySize");
			listOfStrings.Add(SystemInfo.graphicsMultiThreaded + "                 graphicsMultiThreaded");
			listOfStrings.Add(SystemInfo.graphicsShaderLevel + "                 graphicsShaderLevel");
			listOfStrings.Add(SystemInfo.graphicsUVStartsAtTop + "                 graphicsUVStartsAtTop");
			listOfStrings.Add(SystemInfo.hasDynamicUniformArrayIndexingInFragmentShaders + "                 hasDynamicUniformArrayIndexingInFragmentShaders");
			listOfStrings.Add(SystemInfo.hasHiddenSurfaceRemovalOnGPU + "                 hasHiddenSurfaceRemovalOnGPU");
			listOfStrings.Add(SystemInfo.hasMipMaxLevel + "                 hasMipMaxLevel");
			listOfStrings.Add(SystemInfo.hdrDisplaySupportFlags + "                 hdrDisplaySupportFlags");
			listOfStrings.Add(SystemInfo.maxComputeBufferInputsCompute + "                 maxComputeBufferInputsCompute");
			listOfStrings.Add(SystemInfo.maxComputeBufferInputsDomain + "                 maxComputeBufferInputsDomain");
			listOfStrings.Add(SystemInfo.maxComputeBufferInputsFragment + "                 maxComputeBufferInputsFragment");
			listOfStrings.Add(SystemInfo.maxComputeBufferInputsGeometry + "                 maxComputeBufferInputsGeometry");
			listOfStrings.Add(SystemInfo.maxComputeBufferInputsHull + "                 maxComputeBufferInputsHull");
			listOfStrings.Add(SystemInfo.maxComputeBufferInputsVertex + "                 maxComputeBufferInputsVertex");
			listOfStrings.Add(SystemInfo.maxComputeWorkGroupSize + "                 maxComputeWorkGroupSize");
			listOfStrings.Add(SystemInfo.maxComputeWorkGroupSizeX + "                 maxComputeWorkGroupSizeX");
			listOfStrings.Add(SystemInfo.maxComputeWorkGroupSizeY + "                 maxComputeWorkGroupSizeY");
			listOfStrings.Add(SystemInfo.maxComputeWorkGroupSizeZ + "                 maxComputeWorkGroupSizeZ");
			listOfStrings.Add(SystemInfo.maxCubemapSize + "                 maxCubemapSize");
			listOfStrings.Add(SystemInfo.maxTextureSize + "                 maxTextureSize");
			listOfStrings.Add(SystemInfo.npotSupport + "                 npotSupport");
			listOfStrings.Add(SystemInfo.operatingSystem + "                 operatingSystem");
			listOfStrings.Add(SystemInfo.operatingSystemFamily + "                 operatingSystemFamily");
			listOfStrings.Add(SystemInfo.processorCount + "                 processorCount");
			listOfStrings.Add(SystemInfo.processorFrequency + "                 processorFrequency");
			listOfStrings.Add(SystemInfo.processorType + "                 processorType");
			listOfStrings.Add(SystemInfo.renderingThreadingMode + "                 renderingThreadingMode");
			listOfStrings.Add(SystemInfo.supportedRandomWriteTargetCount + "                 supportedRandomWriteTargetCount");
			listOfStrings.Add(SystemInfo.supportedRenderTargetCount + "                 supportedRenderTargetCount");
			listOfStrings.Add(SystemInfo.supports2DArrayTextures + "                 supports2DArrayTextures");
			listOfStrings.Add(SystemInfo.supports32bitsIndexBuffer + "                 supports32bitsIndexBuffer");
			listOfStrings.Add(SystemInfo.supports3DRenderTextures + "                 supports3DRenderTextures");
			listOfStrings.Add(SystemInfo.supports3DTextures + "                 supports3DTextures");
			listOfStrings.Add(SystemInfo.supportsAccelerometer + "                 supportsAccelerometer");
			listOfStrings.Add(SystemInfo.supportsAsyncCompute + "                 supportsAsyncCompute");
			listOfStrings.Add(SystemInfo.supportsAsyncGPUReadback + "                 supportsAsyncGPUReadback");
			listOfStrings.Add(SystemInfo.supportsAudio + "                 supportsAudio");
			listOfStrings.Add(SystemInfo.supportsCompressed3DTextures + "                 supportsCompressed3DTextures");
			listOfStrings.Add(SystemInfo.supportsComputeShaders + "                 supportsComputeShaders");
			listOfStrings.Add(SystemInfo.supportsConservativeRaster + "                 supportsConservativeRaster");
			listOfStrings.Add(SystemInfo.supportsCubemapArrayTextures + "                 supportsCubemapArrayTextures");
			listOfStrings.Add(SystemInfo.supportsGeometryShaders + "                 supportsGeometryShaders");
			listOfStrings.Add(SystemInfo.supportsGpuRecorder + "                 supportsGpuRecorder");
			listOfStrings.Add(SystemInfo.supportsGraphicsFence + "                 supportsGraphicsFence");
			listOfStrings.Add(SystemInfo.supportsGyroscope + "                 supportsGyroscope");
			listOfStrings.Add(SystemInfo.supportsHardwareQuadTopology + "                 supportsHardwareQuadTopology");
			listOfStrings.Add(SystemInfo.supportsInstancing + "                 supportsInstancing");
			listOfStrings.Add(SystemInfo.supportsLocationService + "                 supportsLocationService");
			listOfStrings.Add(SystemInfo.supportsMipStreaming + "                 supportsMipStreaming");
			listOfStrings.Add(SystemInfo.supportsMotionVectors + "                 supportsMotionVectors");
			listOfStrings.Add(SystemInfo.supportsMultisampleAutoResolve + "                 supportsMultisampleAutoResolve");
			listOfStrings.Add(SystemInfo.supportsMultisampled2DArrayTextures + "                 supportsMultisampled2DArrayTextures");
			listOfStrings.Add(SystemInfo.supportsMultisampledTextures + "                 supportsMultisampledTextures");
			listOfStrings.Add(SystemInfo.supportsMultiview + "                 supportsMultiview");
			listOfStrings.Add(SystemInfo.supportsRawShadowDepthSampling + "                 supportsRawShadowDepthSampling");
			listOfStrings.Add(SystemInfo.supportsRayTracing + "                 supportsRayTracing");
			listOfStrings.Add(SystemInfo.supportsRenderTargetArrayIndexFromVertexShader + "                 supportsRenderTargetArrayIndexFromVertexShader");
			listOfStrings.Add(SystemInfo.supportsSeparatedRenderTargetsBlend + "                 supportsSeparatedRenderTargetsBlend");
			listOfStrings.Add(SystemInfo.supportsSetConstantBuffer + "                 supportsSetConstantBuffer");
			listOfStrings.Add(SystemInfo.supportsShadows + "                 supportsShadows");
			listOfStrings.Add(SystemInfo.supportsSparseTextures + "                 supportsSparseTextures");
			listOfStrings.Add(SystemInfo.supportsTessellationShaders + "                 supportsTessellationShaders");
			listOfStrings.Add(SystemInfo.supportsTextureWrapMirrorOnce + "                 supportsTextureWrapMirrorOnce");
			listOfStrings.Add(SystemInfo.supportsVibration + "                 supportsVibration");
			listOfStrings.Add(SystemInfo.systemMemorySize + "                 systemMemorySize");
			listOfStrings.Add(SystemInfo.unsupportedIdentifier + "                 unsupportedIdentifier");
			listOfStrings.Add(SystemInfo.usesLoadStoreActions + "                 usesLoadStoreActions");
			listOfStrings.Add(SystemInfo.usesReversedZBuffer + "                 usesReversedZBuffer");		
	
	
			WriteToFile(pathFileWrite, listOfStrings);

		}



		static void WriteToFile(string filePath, List<string> strings)
   		{
        // Use a using statement to ensure the StreamWriter is properly disposed
       		using (StreamWriter writer = new StreamWriter(filePath))
       		{
       		    // Write each string to the file
       		    foreach (string str in strings)
       		    {
       		        writer.WriteLine(str);
       		    }
       		}
    	}

    }

}