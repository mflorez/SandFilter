using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SandFilter
{
    public class OptionEntity
    {
        #region "Fields"
        public string Id { get; set; }
        /// <summary>
        /// Gets or sets the title.
        /// </summary>
        /// <value>The title.</value>
        public string Title { get; set; }
        #endregion

        #region "Constructor"
        public OptionEntity()
        {
        }
        #endregion
    }
}
