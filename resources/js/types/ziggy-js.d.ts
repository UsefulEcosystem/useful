declare module 'ziggy-js' {
    interface Route {
      (name: string, params?: any, absolute?: boolean): string;
      current: (params?: any) => boolean;
    }
  
    const route: Route;
    export default route;
}