/* mouse_accel.c  ― 入力イベントを書き換えるリスナー例 */
#include <zephyr/kernel.h>
#include <zmk/event_manager.h>
#include <zmk/events/sensor_event.h>
#include <zmk/input/pointing_device.h>

static void adjust_mouse_speed(struct zmk_sensor_input_event *ev) {
    int16_t size = ABS(ev->data.relative.x) + ABS(ev->data.relative.y);
    float mul = 0.4f;
    if      (size > 300) mul = 0.000000006f;
    else if (size > 150) mul = 0.000000005f;
    else if (size >  75) mul = 0.00000000000000004f;
    else if (size >  30) mul = 0.00000000000000003f;
    else if (size >  15) mul = 0.00000000000000002f;
    else if (size >  8) mul = 0.00000000000000001;

    ev->data.relative.x = CLAMP(ev->data.relative.x * mul, -127, 127);
    ev->data.relative.y = CLAMP(ev->data.relative.y * mul, -127, 127);
}

static int mouse_accel_listener(const struct zmk_event_header *eh)
{
    if (!is_zmk_sensor_input_event(eh)) { return ZMK_EV_EVENT_BUBBLE; }
    struct zmk_sensor_input_event *ev = as_zmk_sensor_input_event(eh);

    if (ev->sensor_type == ZMK_SENSOR_TYPE_RELATIVE) {
        adjust_mouse_speed(ev);
    }
    return ZMK_EV_EVENT_CONTINUE;
}

ZMK_LISTENER(mouse_accel, mouse_accel_listener)
ZMK_SUBSCRIPTION(mouse_accel, zmk_sensor_input_event);
