<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\App;

class SetLocale
{
    /**
     * Handle an incoming request.
     */
    public function handle(Request $request, Closure $next)
    {
        // Define o locale padrão da aplicação para pt_BR.
        // Se quiser determinar dinamicamente por usuário/token/cookie, altere aqui.
        App::setLocale('pt_BR');

        return $next($request);
    }
}
