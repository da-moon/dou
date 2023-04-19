using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Training.WebAPI.Middlewares
{
    public class FactoryActivatedCustomMiddleware : IMiddleware
    {
        public async Task InvokeAsync(HttpContext context, RequestDelegate next)
        {
            Console.WriteLine("Logica generica en la clase FactoryActivatedCustomMiddleware");

            await next.Invoke(context);
        }
    }
}
