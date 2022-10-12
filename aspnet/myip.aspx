<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title>MY IP</title>
</head>
<body>
    <form id="form1" runat="server">
      <pre>
REMOTE_ADDR:          <%= Request.ServerVariables["REMOTE_ADDR"] %>
HTTP_X_FORWARDED_FOR: <%= Request.ServerVariables["HTTP_X_FORWARDED_FOR"] %>
HTTP_True-Client-IP:  <%= Request.ServerVariables["HTTP_True-Client-IP"] %>
      </pre>
    </form>
</body>
</html>
