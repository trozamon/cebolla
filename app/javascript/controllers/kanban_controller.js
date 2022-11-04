import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['card', 'inProgress', 'new', 'recentlyCompleted', 'resolved']

  connect() {
    this.cardTargets.forEach(card => {
      card.addEventListener('dragstart', function(event) {
        const id = card.getAttribute('data-id')
        event.dataTransfer.setData('text/plain', id)
      })
    })

    this.setupDropTarget(this.inProgressTarget, this.inProgressTask.bind(this))
    this.setupDropTarget(this.newTarget, this.newTask.bind(this))
    this.setupDropTarget(this.recentlyCompletedTarget, this.completeTask.bind(this))
    this.setupDropTarget(this.resolvedTarget, this.resolveTask.bind(this))
  }

  setupDropTarget(target, handler) {
    target.addEventListener('dragenter', (event) => {
      event.preventDefault()
    })

    target.addEventListener('dragover', (event) => {
      event.preventDefault()
    })

    target.addEventListener('drop', (event) => {
      const id = event.dataTransfer.getData('text/plain')
      handler(id)
    })
  }

  doTask(id, action) {
    const form = document.querySelector('#task-sub')
    form.setAttribute('action', `/tasks/${id}/${action}`)
    form.submit()
  }

  completeTask(id) {
    this.doTask(id, 'complete')
  }

  inProgressTask(id) {
    this.doTask(id, 'start')
  }

  newTask(id) {
    this.doTask(id, 'unstart')
  }

  resolveTask(id) {
    this.doTask(id, 'resolve')
  }
}
