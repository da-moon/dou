using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.OpenApi.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Training.WebAPI.Extensions;
using Training.WebAPI.Middlewares;

namespace Training.WebAPI
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddTransient<FactoryActivatedCustomMiddleware>();
            services.AddControllers();
            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo { Title = "Training.WebAPI", Version = "v1" });
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "Training.WebAPI v1"));
            }

            //app.ConfigureExceptionHandler();
            app.UseExceptionMiddleware();

            app.UseHttpsRedirection();

            app.UseRouting();
            app.UseCors();

            app.UseAuthorization();


            //app.UseCustomMiddleware();
            //app.UseFactoryActivatedCustomMiddleware();


            //app.Use(async (context, next) =>
            //{
            //    Console.WriteLine("Logica que se ejecuta antes del siguiente middleware");
            //    //await context.Response.WriteAsync("Hello from middleware component | Use method");

            //    await next.Invoke();

            //    Console.WriteLine("Response 1");
            //});

            //app.Map("/myCustomUrlMiddleware", builder =>
            //{
            //    builder.Use(async (context, next) =>
            //    {
            //        Console.WriteLine("Logica map que se ejecuta antes del siguiente middleware");

            //        await next.Invoke();

            //        Console.WriteLine("Response myCustomUrlMiddleware");
            //    });

            //    builder.Run(async context =>
            //    {
            //        Console.WriteLine("Logica map que se ejecuta en el siguiente middleware del myCustomUrlMiddleware");

            //        await context.Response.WriteAsync("Hello from middleware component Response | myCustomUrlMiddleware");
            //    });
            //});

            //app.MapWhen(context => context.Request.Query.ContainsKey("mytestparameter"), builder =>
            //{
            //    builder.Run(async context =>
            //    {
            //        await context.Response.WriteAsync("Hello from middleware component MapWhen");
            //    });
            //});

            //app.Run(async context =>
            //{
            //    Console.WriteLine("Sobrescribiendo el response en el metodo Run");
            //    // context.Response.StatusCode = 400;

            //    await context.Response.WriteAsync("Hello from middleware component");
            //});


            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
