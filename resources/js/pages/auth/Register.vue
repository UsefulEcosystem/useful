<script setup lang="ts">
import InputError from '@/components/InputError.vue';
import TextLink from '@/components/TextLink.vue';
import { Button } from '@/components/ui/button';
import {
    Card,
    CardContent,
    CardDescription,
    CardFooter,
    CardHeader,
    CardTitle,
} from '@/components/ui/card';
import {
    Collapsible,
    CollapsibleContent,
    CollapsibleTrigger,
} from '@/components/ui/collapsible';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Switch } from '@/components/ui/switch';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import AuthBase from '@/layouts/AuthLayout.vue';
import { login } from '@/routes';
import { store } from '@/routes/register';
import { Form, Head } from '@inertiajs/vue3';
import { LoaderCircle } from 'lucide-vue-next';
import { ref } from 'vue';

const isOpenNotificationsEmail = ref(false);
const isOpenConditions = ref(false);
const isOpenTerms = ref(false);
const email = ref('');
const currentStep = ref('account');
const switchTermPrivacy = ref(true)
const switchTermUse = ref(true)
const switchTermNotificationEmail = ref(false)

const nextStep = () => {
    if (currentStep.value === 'account') {
        currentStep.value = 'verification';
        email.value =
            document.querySelector<HTMLInputElement>('input[name="email"]')
                ?.value || '';
    } else if (currentStep.value === 'verification')
        currentStep.value = 'terms';
    else if (currentStep.value === 'terms') currentStep.value = 'payment';
};
const prevStep = () => {
    if (currentStep.value === 'payment') currentStep.value = 'terms';
    else if (currentStep.value === 'terms') currentStep.value = 'verification';
    else if (currentStep.value === 'verification')
        currentStep.value = 'account';
};

const validationInfoAccount = () => {
    // Placeholder for future validation logic
};
</script>

<template>
    <AuthBase title="Criar uma conta"
        description="Insira seus dados e realize o pagamento se necessário para ter sua conta ativa rapidamente.">

        <Head title="Register" />

        <Form v-bind="store.form()" :reset-on-success="['password', 'password_confirmation']"
            v-slot="{ errors, processing }" class="flex flex-col gap-6">
            <Tabs v-model="currentStep" :default-value="currentStep" class="w-[auto]">
                <TabsList>
                    <TabsTrigger value="account" :disabled="currentStep !== 'account'">
                        Conta
                    </TabsTrigger>
                    <TabsTrigger value="verification" :disabled="currentStep !== 'verification'">
                        Verificação
                    </TabsTrigger>
                    <TabsTrigger value="terms" :disabled="currentStep !== 'terms'">
                        Termos
                    </TabsTrigger>
                    <TabsTrigger value="payment" :disabled="currentStep !== 'payment'">
                        Pagamento
                    </TabsTrigger>
                </TabsList>
                <TabsContent value="account">
                    <Card>
                        <CardHeader>
                            <CardTitle>Conta</CardTitle>
                            <CardDescription>
                                Essas informações serão usadas nos sistemas que
                                você acessar dentro da nossa plataforma, tanto
                                para acessa-los quanto para personaliza-los.
                            </CardDescription>
                        </CardHeader>
                        <CardContent class="space-y-1">
                            <div class="grid gap-6">
                                <div class="grid gap-2">
                                    <Label for="name">Nome / Razão Social<span style="color: red">*</span></Label>
                                    <Input id="name" type="text" required autofocus :tabindex="1" autocomplete="name"
                                        name="name" placeholder="Nome ou apelido" />
                                    <InputError :message="errors.name" />
                                </div>
                                <div class="grid gap-2">
                                    <Label for="picture">Foto / Logo</Label>
                                    <Input id="picture" name="picture" type="file" accept=".png,.jpg" />
                                </div>
                                <div class="grid gap-2">
                                    <Label for="email">Email<span style="color: red">*</span></Label>
                                    <Input id="email" type="email" required :tabindex="2" autocomplete="email"
                                        name="email" placeholder="email@exemplo.com" />
                                    <InputError :message="errors.email" />
                                </div>
                                <div class="grid gap-2">
                                    <Label for="password">Senha<span style="color: red">*</span></Label>
                                    <Input id="password" type="password" required :tabindex="3"
                                        autocomplete="new-password" name="password" placeholder="Senha" />
                                    <InputError :message="errors.password" />
                                    <Input id="password_confirmation" type="password" required :tabindex="4"
                                        autocomplete="new-password" name="password_confirmation"
                                        placeholder="Confirmar senha" />
                                    <InputError :message="errors.password_confirmation" />
                                </div>
                            </div>
                        </CardContent>
                        <CardFooter class="flex justify-end">
                            <Button type="button" @click.prevent="validationInfoAccount()" @click="nextStep()"
                                :disabled="processing">
                                <LoaderCircle v-if="processing" class="h-4 w-4 animate-spin" />
                                Continuar
                            </Button>
                        </CardFooter>
                    </Card>
                    <div class="text-center text-sm mt-2 text-muted-foreground">
                        Já tem uma conta?
                        <TextLink :href="login()" class="underline underline-offset-4" :tabindex="6">
                            Entrar
                        </TextLink>
                    </div>
                </TabsContent>
                <TabsContent value="verification">
                    <Card>
                        <CardHeader>
                            <CardTitle>Verificação</CardTitle>
                            <CardDescription>
                                Foi encaminhado um código de verificação para
                                email {{ email }}. Insira-o abaixo para
                                continuar com o cadastro de suas credenciais.
                            </CardDescription>
                        </CardHeader>
                        <CardContent class="space-y-1">
                            <div class="grid gap-6">
                                <div class="grid gap-2">

                                    <Input id="code_verification_email" name="code_verification_email" type="text"
                                        placeholder="" required />
                                    <InputError :message="errors.code_verification_email
                                        " />


                                </div>
                            </div>
                        </CardContent>
                        <CardFooter class="flex justify-end w-full max-w-sm items-center gap-1.5">
                            <Button type="button" @click="prevStep()" :disabled="processing">
                                Voltar
                            </Button>
                            <Button @click="nextStep()" :disabled="processing">
                                <LoaderCircle v-if="processing" class="h-4 w-4 animate-spin" />
                                Continuar
                            </Button>
                        </CardFooter>
                    </Card>
                </TabsContent>
                <TabsContent value="terms">
                    <Card>
                        <CardHeader>
                            <CardTitle>Termos e condições</CardTitle>
                            <CardDescription> </CardDescription>
                        </CardHeader>
                        <CardContent class="space-y-1">
                            <div class="grid gap-6">
                                <div class="grid gap-2">
                                    <Collapsible v-model:open="isOpenTerms">
                                        <div class="flex items-center space-x-2">
                                            <Switch id="term-use" v-model="switchTermUse" disabled="disabled" />
                                            <CollapsibleTrigger>

                                                <Label for="term-use" class="cursor-pointer">
                                                    Aceite dos Termos de Uso
                                                </Label>

                                            </CollapsibleTrigger>
                                        </div>
                                        <CollapsibleContent>
                                            Yes. Free to use for personal and
                                            commercial projects. No attribution
                                            required.
                                        </CollapsibleContent>
                                    </Collapsible>
                                    <Collapsible v-model:open="isOpenConditions">
                                        <div class="flex items-center space-x-2">
                                            <Switch id="term-privacy" v-model="switchTermPrivacy" disabled="disabled" />
                                            <CollapsibleTrigger>
                                                <Label for="term-privacy" class="cursor-pointer">Aceite da Política de
                                                    Privacidade</Label>
                                            </CollapsibleTrigger>
                                        </div>
                                        <CollapsibleContent>
                                            Yes. Free to use for personal and
                                            commercial projects. No attribution
                                            required.
                                        </CollapsibleContent>
                                    </Collapsible>
                                    <Collapsible v-model:open="isOpenNotificationsEmail">
                                        <div class="flex items-center space-x-2">
                                            <Switch id="term-notification-email"
                                                v-model="switchTermNotificationEmail" />
                                            <CollapsibleTrigger>
                                                <Label class="cursor-pointer">
                                                    Consentimento para recebere-mails promocionais
                                                </Label>
                                            </CollapsibleTrigger>
                                        </div>

                                        <CollapsibleContent>
                                            Texto extra que aparece só quando
                                            clicar na Label.
                                        </CollapsibleContent>
                                    </Collapsible>
                                </div>
                            </div>
                        </CardContent>
                        <CardFooter class="flex justify-end w-full max-w-sm items-center gap-1.5">
                            <Button type="button" @click="prevStep()" :disabled="processing">
                                Voltar
                            </Button>
                            <Button type="button" @click="nextStep()" :disabled="processing">
                                <LoaderCircle v-if="processing" class="h-4 w-4 animate-spin" />
                                Continuar
                            </Button>
                        </CardFooter>
                    </Card>
                </TabsContent>
                <TabsContent value="payment">
                    <Card>
                        <CardHeader>
                            <CardTitle>Pagamento</CardTitle>
                            <CardDescription>
                                Escolha um plano para continuar com o
                                cadastro de suas credenciais.
                            </CardDescription>
                        </CardHeader>
                        <CardContent class="space-y-1">
                            <div class="grid gap-6">
                                <div class="grid gap-2">
                                    Plano de pagamento placeholder
                                </div>
                            </div>
                        </CardContent>
                        <CardFooter class="flex justify-end w-full max-w-sm items-center gap-1.5">
                            <Button type="button" @click="prevStep()" :disabled="processing">
                                Voltar
                            </Button>
                            <Button type="submit" class="w-auto sm:w-65" tabindex="5" :disabled="processing"
                                data-test="register-user-button">
                                <LoaderCircle v-if="processing" class="h-4 w-4 animate-spin" />
                                Finalizar
                            </Button>
                        </CardFooter>
                    </Card>
                </TabsContent>
            </Tabs>
        </Form>
    </AuthBase>
</template>
