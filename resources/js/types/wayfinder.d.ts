declare module '@/routes' {
    const route: any;
    export { route };
    const defaultExport: any;
    export default defaultExport;
}

declare module '@/routes/*' {
    const route: any;
    export { route };
    const mod: any;
    export default mod;
}

declare module '@/actions/*' {
    const mod: any;
    export default mod;
}


