<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="EPiServer.Logging" %>
<%@ Import Namespace="log4net" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>Test log4net</title>
</head>
<body>
  <script language="c#" runat="server">

    private static readonly Dictionary<string, Action> ActionMap = new Dictionary<string, Action>
    {
      { "EPiServer_ERROR", () => GetEpiServerLogger().Error(GetLogMessage()) },
      { "EPiServer_WARN", () => GetEpiServerLogger().Warning(GetLogMessage()) },
      { "EPiServer_INFO", () => GetEpiServerLogger().Information(GetLogMessage()) },
      { "EPiServer_DEBUG", () => GetEpiServerLogger().Debug(GetLogMessage()) },
      { "Log4net_ERROR", () => GetLog4netLogger().Error(GetLogMessage()) },
      { "Log4net_WARN", () => GetLog4netLogger().Warn(GetLogMessage()) },
      { "Log4net_INFO", () => GetLog4netLogger().Info(GetLogMessage()) },
      { "Log4net_DEBUG", () => GetLog4netLogger().Debug(GetLogMessage()) },
    };

    private static ILogger GetEpiServerLogger()
    {
      return EPiServer.Logging.LogManager.Instance.GetLogger("Test EPiServer logger");
    }

    private static ILog GetLog4netLogger()
    {
      return log4net.LogManager.GetLogger("Test log4net logger");
    }

    private static string GetLogMessage()
    {
      return "Test Log Message";
    }

    private static string AllUrls()
    {
      var key = HttpContext.Current.Request.QueryString["log"];

      Action action;
      if (key != null && ActionMap.TryGetValue(key, out action))
      {
        action();
      }

      return DateTime.UtcNow.ToString("yyyy-MM-dd HH:mm:ss.fff", CultureInfo.InvariantCulture) + " UTC\n" +
             DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff", CultureInfo.InvariantCulture) + " local\n\n" +
             string.Join("\n", ActionMap.Select(x => "<a href='?log=" + x.Key + "'>" + x.Key + "</a>"));
    }

  </script>
  <form runat="server">
    <pre><%= AllUrls() %></pre>
  </form>
</body>
</html>
