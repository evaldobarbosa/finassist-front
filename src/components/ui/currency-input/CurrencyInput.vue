<script setup lang="ts">
import { ref, watch, computed } from 'vue'

const props = defineProps<{
  modelValue?: number
  placeholder?: string
  disabled?: boolean
  class?: string
}>()

const emit = defineEmits<{
  'update:modelValue': [value: number]
}>()

const displayValue = ref('')

function formatForDisplay(value: number): string {
  if (!value && value !== 0) return ''
  return new Intl.NumberFormat('pt-BR', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2
  }).format(value)
}

function parseFromDisplay(value: string): number {
  if (!value) return 0
  const cleaned = value.replace(/\./g, '').replace(',', '.')
  return parseFloat(cleaned) || 0
}

watch(() => props.modelValue, (newValue) => {
  if (newValue !== undefined) {
    displayValue.value = formatForDisplay(newValue)
  }
}, { immediate: true })

function handleInput(event: Event) {
  const target = event.target as HTMLInputElement
  let value = target.value.replace(/[^\d,]/g, '')

  // Ensure only one comma
  const parts = value.split(',')
  if (parts.length > 2) {
    value = parts[0] + ',' + parts.slice(1).join('')
  }

  // Limit decimal places
  if (parts.length === 2 && parts[1].length > 2) {
    value = parts[0] + ',' + parts[1].slice(0, 2)
  }

  displayValue.value = value
  emit('update:modelValue', parseFromDisplay(value))
}

function handleBlur() {
  const numValue = parseFromDisplay(displayValue.value)
  displayValue.value = formatForDisplay(numValue)
}
</script>

<template>
  <div class="relative">
    <span class="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground">R$</span>
    <input
      type="text"
      inputmode="decimal"
      :value="displayValue"
      :placeholder="placeholder || '0,00'"
      :disabled="disabled"
      :class="[
        'flex h-10 w-full rounded-md border border-input bg-background pl-10 pr-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50',
        props.class
      ]"
      @input="handleInput"
      @blur="handleBlur"
    />
  </div>
</template>
