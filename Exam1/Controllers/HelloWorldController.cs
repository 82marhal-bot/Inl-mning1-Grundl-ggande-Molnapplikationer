using Microsoft.AspNetCore.Mvc;

namespace Exam1.Controllers
{
    public class HelloWorldController : Controller
    {
        public IActionResult Index()
        {
            ViewData["Message"] = "Welcome to the magical unicorn world!";
            return View();
        }
    }
}
