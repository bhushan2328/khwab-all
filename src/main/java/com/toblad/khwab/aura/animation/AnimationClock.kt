package com.toblad.khwab.aura.animation

/**
 * ------------------------------------------------------------------
 * Khwab Aura
 * ------------------------------------------------------------------
 *
 * Central timing source for Aura.
 *
 * Future versions will drive:
 * - Sun movement
 * - Moon movement
 * - Cloud movement
 * - Weather animation
 * - Lighting transitions
 * - Particle systems
 *
 * The clock itself contains no rendering logic.
 * ------------------------------------------------------------------
 */
class AnimationClock {

    /**
     * Elapsed animation time in seconds.
     */
    private var elapsedSeconds: Float = 0f

    /**
     * Advances the clock.
     *
     * @param deltaSeconds Time since the previous frame.
     */
    fun update(
        deltaSeconds: Float
    ) {
        elapsedSeconds += deltaSeconds
    }

    /**
     * Returns the current elapsed animation time.
     */
    fun elapsedTime(): Float =
        elapsedSeconds

    /**
     * Resets the clock.
     */
    fun reset() {
        elapsedSeconds = 0f
    }
}
