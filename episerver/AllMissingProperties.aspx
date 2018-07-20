<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="EPiServer.DataAbstraction" %>
<%@ Import Namespace="EPiServer.ServiceLocation" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>Properties missing in code</title>
</head>
<body>
  <script language="c#" runat="server">
    private static string[] GetInfo()
    {
      const string AdminRoot = "/EPiServer/CMS/Admin/";

      var contentTypeRepository = ServiceLocator.Current.GetInstance<IContentTypeRepository>();
      var contentTypeModelRepository = ServiceLocator.Current.GetInstance<ContentTypeModelRepository>();

      return contentTypeRepository
        .List()
        .SelectMany(t => t.PropertyDefinitions
          .Select(p => new
          {
            Type = t,
            TypeName = t.LocalizedFullName,
            Property = p,
            PropertyName = p.Name,
            PropertyIsMissed = p.ExistsOnModel && contentTypeModelRepository.GetPropertyModel(p.ContentTypeID, p) == null,
          }))
        .Where(x => x.PropertyIsMissed)
        .OrderBy(x => x.TypeName)
        .ThenBy(x => x.PropertyName)
        .Select(x => "<a href='" + AdminRoot + "EditContentType.aspx?typeId=" + x.Type.ID + "'>" + x.TypeName + "</a> - <a href='" + AdminRoot + "EditPropertyDefinition.aspx?typeId=" + x.Property.ID + "'>" + x.PropertyName + "</a>")
        .ToArray();
    }
  </script>
  <form runat="server">
    <pre><%= string.Join("\r\n", GetInfo()) %></pre>
  </form>
</body>
</html>
