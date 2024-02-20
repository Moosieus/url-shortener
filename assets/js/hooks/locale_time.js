export function localizeTimestamp() {
    const t = this.el.textContent.trim()
    
    const d = new Date(t)

    this.el.textContent = d.toLocaleString()
}

export default {
    mounted: localizeTimestamp,
    updated: localizeTimestamp,
}