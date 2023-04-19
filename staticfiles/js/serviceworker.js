self.addEventListener('fetch', e => {
   var offlineResp = new Response(`
      <!DOCTYPE html>
      <html>

      <head>
         <meta charset="utf-8">
         <meta http-equiv="X-UA-Compatible" content="IE=edge">
         <title>Details</title>
         <meta name="viewport" content="width=device-width, initial-scale=1">
         <style>
            html, body {
               width: 100%;
               heigth: 100%;
               padding: 0;
               margin: 0;
               background: #3498db;
               font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif
            }

            h1, h3 {
               width: 100%;
               text-align: center;
            }

            svg {
               margin-top: 2rem;
            }
         </style>
      </head>

      <body>
         <h1>Lo sentimos</h1>
         <h3>Vuele cuando tengas conexión a Internet<h3>
         <svg width="100%" height="100%">
            <rect width="100%" height="100%" fill="red"/>
            <circle cx="100%" cy="100%" r="150" fill="blue" stroke="black"/>
            <polygon points="120,0 240,225 0,225" fill="green"/>
            <text x="50" y="100" font-family="Verdana" font-size="55"
               fill="white" stroke="black" stroke-width="2">
               Hello!
            </text>
         </svg>
      </body>

      </html>
   `, {
      headers: {
         'Content-Type': 'text/html'
      }
   });

   const resp = fetch(e.request)
      .catch(() => offlineResp);
   e.respondWith(resp);
});