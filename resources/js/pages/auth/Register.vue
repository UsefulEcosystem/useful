<script setup lang="ts">
import InputError from '@/components/InputError.vue';
import TextLink from '@/components/TextLink.vue';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardFooter } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import AuthBase from '@/layouts/AuthLayout.vue';
import { store } from '@/routes/register';
import { Form, Head } from '@inertiajs/vue3';
import { LoaderCircle } from 'lucide-vue-next';
import * as routes from '@/routes';
import { ref } from 'vue';
const login = (routes as any).login;
const name = ref('');
</script>

<template>
    <AuthBase title="Crie uma conta" description="Cadastre-se rapidamente e tenha acesso ao painel de controle.">

        <Head title="Register" />

        <Form v-bind="store.form()" :reset-on-success="['password', 'password_confirmation']"
            v-slot="{ errors, processing }" class="flex flex-col gap-6">
            <Card>
                <CardContent>
                    <div class="grid gap-6">
                        <div class="grid gap-2">
                            <Label for="name">Nome<span style="color: red">*</span></Label>
                            <Input id="name" type="text" required autofocus :tabindex="1" autocomplete="name"
                                name="name" v-model="name" placeholder="Nome ou apelido" />
                            <InputError :message="errors.name" />
                        </div>
                        <div class="grid gap-2">
                            <Label for="email">Email<span style="color: red">*</span></Label>
                            <Input id="email" type="email" required :tabindex="2" autocomplete="email" name="email"
                                placeholder="Email" />
                            <InputError :message="errors.email" />
                            <Input id="email_confirmation" type="email" required :tabindex="2" autocomplete="email"
                                name="email_confirmation" placeholder="Confirmar email" />
                            <InputError :message="errors.email_confirmation" />
                        </div>
                        <div class="grid gap-2">
                            <Label for="password">Senha<span style="color: red">*</span></Label>
                            <Input id="password" type="password" required :tabindex="3" autocomplete="password"
                                name="password" placeholder="Senha" />
                            <InputError :message="errors.password" />
                            <Input id="password_confirmation" type="password" required :tabindex="4"
                                autocomplete="password-confirmation" name="password_confirmation"
                                placeholder="Confirmar senha" />
                            <InputError :message="errors.password_confirmation" />
                        </div>
                    </div>
                </CardContent>
                <CardFooter class="flex justify-center w-full max-w-sm items-center gap-1.5">
                    <Button type="submit" :tabindex="5" class="w-full" :disabled="processing"
                        data-test="register-user-button">
                        <LoaderCircle v-if="processing" class="h-4 w-4 animate-spin" />
                        Criar
                    </Button>
                </CardFooter>
            </Card>
            <div class="text-center text-sm text-muted-foreground">
                Já tem uma conta?
                <TextLink :href="login()" class="underline underline-offset-4">
                    Entrar
                </TextLink>
            </div>
        </Form>
    </AuthBase>
</template>
