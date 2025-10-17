import '../css/app.css';

import { createInertiaApp } from '@inertiajs/vue3';
import { resolvePageComponent } from 'laravel-vite-plugin/inertia-helpers';
import type { DefineComponent } from 'vue';
import { createApp, h } from 'vue';

// === Template imports ===
import { useData } from '@template/composables/data.js';
import { useLanguage } from '@template/composables/language.js';
import { useNavigation } from '@template/composables/navigation.js';
import { createAppRouter } from '@template/router/router.js';
import { initializeTheme } from './composables/useAppearance';

const appName = import.meta.env.VITE_APP_NAME || 'Laravel';

// Aplica o tema claro/escuro do sistema
initializeTheme();

const data = useData();

data.fetchEssentials().then(() => {
    const language = useLanguage();
    language.init((data.getSettings() as { supportedLanguages: string[] }).supportedLanguages);

    const navigation = useNavigation();
    navigation.init(data.getSections(), data.getCategories());

    const router = createAppRouter();

    createInertiaApp({
        title: (title) => (title ? `${title} - ${appName}` : appName),
        resolve: (name) =>
            resolvePageComponent(
                `./pages/${name}.vue`,
                import.meta.glob<DefineComponent>('./pages/**/*.vue'),
            ),
        setup({ el, App, props, plugin }) {
            createApp({ render: () => h(App, props) })
                .use(plugin)
                .use(router)
                .mount(el);
        },
        progress: {
            color: '#4B5563',
        },
    });
});
