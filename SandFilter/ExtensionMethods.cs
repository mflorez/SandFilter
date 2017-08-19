using Microsoft.SharePoint;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SandFilter
{
    public static class ExtensionMethods
    {
        public static bool HasView(this SPList list, string viewName)
        {
            if (string.IsNullOrEmpty(viewName))
            {
                return false;
            }
            foreach (SPView view in list.Views)
            {
                if (view.Title.ToLowerInvariant() == viewName.ToLowerInvariant())
                {
                    return true;
                }

            }
            return false;
        }
    }
}
