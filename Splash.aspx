<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Influish — Connect • Create • Grow</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet" />
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'><rect width='32' height='32' rx='8' fill='%237C3AED'/><path d='M16 4L19.5 12.5L28 16L19.5 19.5L16 28L12.5 19.5L4 16L12.5 12.5Z' fill='white'/></svg>" />
    <link href="~/Content/influish.css" rel="stylesheet" type="text/css" runat="server" />
    <link href="~/favicon.ico" rel="shortcut icon" type="image/x-icon" runat="server" />
    <style>
        body, html {
            height: 100%;
            margin: 0;
            background: radial-gradient(circle at 80% 20%, rgba(236,72,153,0.12) 0%, rgba(248,247,255,1) 50%, rgba(124,58,237,0.08) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Inter', sans-serif;
            overflow: hidden;
        }
        .splash-card {
            text-align: center;
            padding: 48px;
            max-width: 440px;
            width: 90%;
            animation: fadeIn 0.8s ease-out forwards;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(16px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .splash-logo-box {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #7C3AED 0%, #EC4899 100%);
            border-radius: 20px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            box-shadow: 0 12px 32px rgba(124,58,237,0.28);
            margin-bottom: 24px;
        }
        .splash-title {
            font-size: 32px;
            font-weight: 900;
            color: #111827;
            margin: 0 0 8px 0;
            letter-spacing: -0.5px;
        }
        .splash-tagline {
            font-size: 13px;
            font-weight: 600;
            color: #7C3AED;
            letter-spacing: 3px;
            text-transform: uppercase;
            margin-bottom: 36px;
        }
        .splash-actions {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .splash-btn-primary {
            background: linear-gradient(135deg, #7C3AED 0%, #EC4899 100%);
            color: #fff;
            padding: 14px 28px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 15px;
            text-decoration: none;
            transition: all 0.2s ease;
            box-shadow: 0 6px 20px rgba(124,58,237,0.25);
        }
        .splash-btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 8px 24px rgba(124,58,237,0.35);
            color: #fff;
        }
        .splash-btn-secondary {
            background: #fff;
            color: #374151;
            border: 1px solid #E5E7EB;
            padding: 13px 28px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 14px;
            text-decoration: none;
            transition: all 0.2s ease;
        }
        .splash-btn-secondary:hover {
            background: #F9FAFB;
            color: #111827;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="splash-card">
            <div class="splash-logo-box">
                <svg width="40" height="40" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12 0L14.59 9.41L24 12L14.59 14.59L12 24L9.41 14.59L0 12L9.41 9.41L12 0Z"/>
                </svg>
            </div>
            <h1 class="splash-title">Influish</h1>
            <div class="splash-tagline">CONNECT &bull; CREATE &bull; GROW</div>

            <div class="splash-actions">
                <a href="~/Default.aspx" runat="server" class="splash-btn-primary">Explore Marketplace &rsaquo;</a>
                <a href="~/Dashboard.aspx" runat="server" class="splash-btn-secondary">Go to Creator Dashboard</a>
            </div>
        </div>
    </form>
</body>
</html>
