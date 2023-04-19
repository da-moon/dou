using Microsoft.AspNetCore.Builder;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Training.WebAPI.Middlewares
{
    public static class MiddlewareExtension
    {
        public static IApplicationBuilder UseCustomMiddleware(this IApplicationBuilder builder) => builder.UseMiddleware<CustomMiddleware>();
        public static IApplicationBuilder UseFactoryActivatedCustomMiddleware(this IApplicationBuilder builder) => builder.UseMiddleware<FactoryActivatedCustomMiddleware>();
        public static IApplicationBuilder UseExceptionMiddleware(this IApplicationBuilder builder) => builder.UseMiddleware<ExceptionMiddleware>();

    }
}
