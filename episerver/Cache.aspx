<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title>Runtiome Cache entries</title>
</head>
<body>
    <form id="form1" runat="server">
      <h2>EPiServer cache usage</h2>
<pre>
<%
    var keys = HttpRuntime.Cache.Cast<DictionaryEntry>().Select(x => (string)x.Key).ToArray();

    var pages = keys.Count(x => x.StartsWith("EPPageData"));
    var listings = keys.Count(x => x.StartsWith("EPChildrenData"));

    var guid = "key:e47e5bdbf61e173decc4";
    if (HttpRuntime.Cache[guid] == null)
    {
        HttpRuntime.Cache[guid] = DateTime.Now;
    }
    var date = ((DateTime)HttpRuntime.Cache[guid]).ToString("yyyy-MM-dd HH:mm:ss.fff");

%>
    Pages:     <%=pages %>
    Listings:  <%=listings %>

    Cache live at least since: <%=date %>
</pre>

      <h2>Count of values by type</h2>
<pre>
<%
    var countOfValuesByType = HttpRuntime.Cache.Cast<DictionaryEntry>().GroupBy(x => x.Value.GetType().FullName).Select(x => new
    {
        Key = x.Key,
        Count = x.Count(),
    }).ToArray();
    foreach (var result in countOfValuesByType.OrderByDescending(x => x.Count))
    { %>
<%= result.Count %>&#09;<%= result.Key %>
<%}

%>
</pre>

      <h2>All values</h2>
<pre>
<%
    foreach (var key in keys.OrderBy(x => x))
    { %>
[<%= key %>]-[<%= HttpRuntime.Cache[key] %>]<%}
%>
</pre>

    </form>
</body>
</html>
