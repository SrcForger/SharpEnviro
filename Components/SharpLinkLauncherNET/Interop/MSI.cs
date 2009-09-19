using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SharpLinkLauncherNET.Interop.Enums;
using System.Runtime.InteropServices;

namespace SharpLinkLauncherNET.Interop
{
    // Big thanks to Greg Zelesnik for a really good code example
    // Source: http://www.geektieguy.com/2007/11/19/how-to-parse-special-lnk-files-aka-msi-shortcuts-aka-windows-installer-advertised-shortcuts-using-c/
    class MSI
    {
        /*
        UINT MsiGetShortcutTarget(
            LPCTSTR szShortcutTarget,
            LPTSTR szProductCode,
            LPTSTR szFeatureId,
            LPTSTR szComponentCode
        );
        */
        [DllImport("msi.dll", CharSet = CharSet.Auto)]
        static extern int MsiGetShortcutTarget(string targetFile, StringBuilder productCode, StringBuilder featureID, StringBuilder componentCode);

        public const int MaxFeatureLength = 38;
        public const int MaxGuidLength = 38;
        public const int MaxPathLength = 1024;

        /*
        INSTALLSTATE MsiGetComponentPath(
          LPCTSTR szProduct,
          LPCTSTR szComponent,
          LPTSTR lpPathBuf,
          DWORD* pcchBuf
        );
        */
        [DllImport("msi.dll", CharSet = CharSet.Auto)]
        static extern InstallState MsiGetComponentPath(string productCode, string componentCode, StringBuilder componentPath, ref int componentPathBufferSize);

        public static string ParseShortcut(string file)
        {
            StringBuilder product = new StringBuilder(MaxGuidLength + 1);
            StringBuilder feature = new StringBuilder(MaxFeatureLength + 1);
            StringBuilder component = new StringBuilder(MaxGuidLength + 1);
            
            MsiGetShortcutTarget(file, product, feature, component);

            int pathLength = MaxPathLength;
            StringBuilder path = new StringBuilder(pathLength);

            InstallState installState = MsiGetComponentPath(product.ToString(), component.ToString(), path, ref pathLength);
            if (installState == InstallState.Local)
            {
                return path.ToString();
            }
            else
            {
                return null;
            }
        }    
    }
}
